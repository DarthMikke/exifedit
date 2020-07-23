//
//  FileListRow.swift
//  EXIF viewer
//
//  Created by Michal Jan Warecki on 23/07/2020.
//  Copyright © 2020 Michal Jan Warecki. All rights reserved.
//

import Foundation
import SwiftUI

struct File: Identifiable {
    let id = UUID()
    let array : Array<String>
}

struct FileListRow : View {
    var file: File
    @Binding var selectedItems: Set<UUID>
    var isSelected: Bool {
        selectedItems.contains(file.id)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(self.file.array[0])
                    .fontWeight(.bold)
                Text(self.file.array[1])
            }
            ForEach(2..<self.file.array.count, id: \.self) { i in
                HStack {
                    Spacer(minLength: 20)
                    Text(self.file.array[i])
                }
            }
        }.background(self.isSelected ? Color.blue : Color.clear)
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
