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
     TODO: The rows update after a click.
    */
    var id = UUID()
    @Binding var filelist: Array<File>
    let index: Int
    @Binding var selectedItems: Set<UUID>
    var isSelected: Bool {
        selectedItems.contains(filelist[index].id)
    }
    @Binding var activeColumns: Array<String>
    @EnvironmentObject var datastore: ContentViewModel
    
    func noActiveColumns() -> Int {
        return self.activeColumns.count
    }
    
    func getColumnByNo(index: Int) -> String {
        guard let ret = self.filelist[self.index].dict[self.activeColumns[index]] else { return "-" }
        print(index)
        print(self.activeColumns)
        return String(ret)
    }
    
    var body: some View {
        HStack {
        VStack(alignment: .center) {
            HStack {
                Text(self.filelist[self.index].dict["filename"]!)
                    .fontWeight(.bold)
                Spacer()
                Text(self.filelist[self.index].dict["extension"]!)
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
                self.selectedItems.remove(self.filelist[self.index].id)
                print("Selected items: \(self.selectedItems)")
                self.datastore.getExif()
            } else {
                self.selectedItems.insert(self.filelist[self.index].id)
                print("Selected items: \(self.selectedItems)")
                self.datastore.getExif()
            }
        }
        .foregroundColor(self.isSelected ? Color.white : Color.black)
        }
        .padding(-10.0)
    }
}

//struct FileListRow_Previews: PreviewProvider {
//    @State var selectKeeper: Set<UUID> = []
//    static var previews: some View {
//        Group {
//            FileListRow(file: File(array: ["File 1", "DNG", "2014:08:02 12:34:56 UTC+0", "Hasselblad"]), selectedItems: Set<UUID>()
//            ).frame(width: 250)
//            FileListRow(file: File(array: ["test", "CR2"]), selectedItems: Set<UUID>()
//            )
//        }
//    }
//}
