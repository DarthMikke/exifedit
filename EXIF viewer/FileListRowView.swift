//
//  FileListRow.swift
//  EXIF viewer
//
//  Created by Michal Jan Warecki on 23/07/2020.
//  Copyright © 2020 Michal Jan Warecki. All rights reserved.
//

import Foundation
import SwiftUI

struct FileListRow : View, Identifiable {
    /**
     TODO: The rows update immediately after a click.
    */
                        var id            = UUID()
                        var file:           File
//    let index: Int
                        var column:         Columns
//    @Binding var selectedItems: Set<UUID>
                        var isSelected:     Bool {
        if (self.column == .primary) {
//            print("FileListRowView: Looking for \(self.file.id) in \(self.datastore.selectedFiles)") // DEBUG
            return self.datastore.selectedFiles.contains(self.file.id)
        } else if (self.column == .secondary) {
            return self.datastore.selectedNewFiles.contains(self.file.id)
        }
        return false
    }
    @Binding            var activeColumns:  Array<String>
    @EnvironmentObject  var datastore:      ContentViewModel
    
    func noActiveColumns() -> Int {
        return self.activeColumns.count
    }
    
    func getColumnByNo(index: Int) -> String {
        let ret = getProperty(self.activeColumns[index])
        return String(ret)
    }
    
    func getProperty(_ index: String) -> String {
        // TODO: Returnerer eigenskap eller "–"
        if (self.file.index < self.datastore.filelist.count) {
            if (self.file.dict.keys.contains(index)) {
                return self.file.dict[index] ?? "??"
            }
        }
        return "–"
    }
    
    var body: some View {
        HStack {
        VStack(alignment: .center) {
            HStack {
                Text(getProperty("filename"))
                    .fontWeight(.bold)
                Spacer()
                Text(getProperty("extension"))
            }
            
            HStack {
                Text(self.getColumnByNo(index: 1))
                ForEach(2..<self.noActiveColumns(), id: \.self) { i in
                    HStack {
                        Spacer(minLength: fileListRowMinSpacer)
                        Text(self.getColumnByNo(index: i))
                    }
                }
            }
        }
        .padding(5.0)
        .padding(.leading, 48.0)
        .background(self.isSelected ? selectedBackground : Color.clear)
        .onTapGesture {
            if(self.isSelected) {
                if (self.column == .primary) {
                    self.datastore.selectedFiles.remove(self.file.id)
                    print("\(#file) \(#line): Selected items: \(self.datastore.selectedFiles)")
                    self.datastore.getExif()
                } else {
                    self.datastore.selectedNewFiles.remove(self.file.id)
                    print("\(#file) \(#line): Selected items: \(self.datastore.selectedNewFiles)")
                }
            } else {
                if (self.column == .primary) {
                    self.datastore.selectedFiles.insert(self.file.id)
                    print("\(#file) \(#line): Selected items: \(self.datastore.selectedFiles)")
                    self.datastore.getExif()
                } else {
                    self.datastore.selectedNewFiles.insert(self.file.id)
                    print("\(#file) \(#line): Selected items: \(self.datastore.selectedNewFiles)")
                }
            }
        }
        .foregroundColor(self.isSelected ? Color.white : Color.black)
        }
        .padding(-10.0)
    }
}
