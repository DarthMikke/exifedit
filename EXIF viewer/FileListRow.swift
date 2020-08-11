//
//  FileListRow.swift
//  EXIF viewer
//
//  Created by Michal Jan Warecki on 23/07/2020.
//  Copyright © 2020 Michal Jan Warecki. All rights reserved.
//

import Foundation
import SwiftUI

class File: Identifiable {
    let id: UUID
    @Published var dict : Dictionary<String, String>
    
    init (dict: Dictionary<String, String>) {
        self.id = UUID()
        self.dict = dict
    }
    
    func changeValue(value: String, to: String) {
        if (value == "Modifikasjonsdato") {
            
        }
    }
}

struct FileListRow : View {
    var file: File
    @Binding var selectedItems: Set<UUID>
    var isSelected: Bool {
        selectedItems.contains(file.id)
    }
    @Binding var activeColumns: Array<String>
    
    func noActiveColumns() -> Int {
        return self.activeColumns.count
    }
    
    func getColumnByNo(index: Int) -> String {
        guard let ret = self.file.dict[self.activeColumns[index]] else { return "-" }
        print(index)
        print(self.activeColumns)
        return String(ret)
    }
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(self.file.dict["filename"]!)
                    .fontWeight(.bold)
                Text(self.file.dict["extension"]!)
            }
            
            ForEach(1..<self.noActiveColumns(), id: \.self) { i in
                HStack {
                    Spacer(minLength: 20)
                    Text(self.getColumnByNo(index: i))
                }
            }
        }
        .background(self.isSelected ? Color.init(red: 0.098, green: 0.4, blue: 0.851) : Color.clear)
        .onTapGesture {
            if(self.isSelected) {
                self.selectedItems.remove(self.file.id)
                print(self.selectedItems)
            } else {
                self.selectedItems.insert(self.file.id)
                print(self.selectedItems)
            }
        }
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
