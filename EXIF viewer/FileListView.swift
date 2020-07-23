//
//  FileListView.swift
//  EXIF viewer
//
//  Created by Michal Jan Warecki on 23/07/2020.
//  Copyright © 2020 Michal Jan Warecki. All rights reserved.
//

import Foundation
import SwiftUI

// Selectable list https://stackoverflow.com/questions/56706188/how-does-one-enable-selections-in-swiftuis-list


struct FileList: View {
    var header: Array<String>
    var files:  Array<File>
    @State var selectKeeper = Set<UUID>()
    
    
    var body : some View {
        VStack {
            Text("Filer:").font(.subheadline).padding(.bottom, 2.0)
            // Header
            HStack() {
                Text(self.header[0])
                    .multilineTextAlignment(.leading).padding(0.0)
                ForEach(1..<self.header.count, id: \.self) { i in
                    HStack {
                        Spacer()//minLength: 20)
                        Text(self.header[i]).multilineTextAlignment(.trailing).padding(0.0)
                    }
                }
                .padding(.trailing, 26.0)
            }
            .padding(.leading, 48.0)
            // The file list itself
            List(0 ..< self.files.count) { i in
                //    Image("Image.png")
                VStack {
                FileListRow(file: self.files[i], selectedItems: self.$selectKeeper)
                    .padding(.leading, 48.0)
                    .contextMenu {
                        Text("Vis i Finder")
                }
                Divider()
                }
            }
            .padding(-8.0)
        }
    }
}

struct FileListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FileList(header: ["Namn", "Dato", "ModelName"],
                     files: [
                        File(array: ["File 0", "CR2", "2020:07:12 12:34:56 UTC+2", "Canon EOS 6D"]),
                        File(array: ["File 1", "DNG", "2014:08:02 12:34:56 UTC+0", "Hasselblad"])
                ]//,
                 //    data: [
//                        ["File 0", "CR2", "2020:07:12 12:34:56 UTC+2"],
  //                      ["File 1", "DNG", "2014:08:02 12:34:56 UTC+0"]
    //            ]
            )
        }
    }
}
