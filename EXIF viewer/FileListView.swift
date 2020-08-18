//
//  FileListView.swift
//  EXIF viewer
//
//  Created by Michal Jan Warecki on 23/07/2020.
//  Copyright © 2020 Michal Jan Warecki. All rights reserved.
//
// Selectable list https://stackoverflow.com/questions/56706188/how-does-one-enable-selections-in-swiftuis-list

import Foundation
import SwiftUI


struct FileList: View {
    var availableColumns: Dictionary<String, String>
    @State var header: Array<String>
    @State var files:  Array<File>
    @State var selectKeeper = Set<UUID>()
    // var visibleHeaders: Set<String> = Set(header)
    
    func update() {
        
    }
    
    var body : some View {
        VStack {
            Text("Filer:").font(.subheadline).padding(.bottom, 2.0)
            /** #Header
             */
            HStack() {
//                Text(String(self.availableColumns["filename"]!))
//                    .multilineTextAlignment(.leading).padding(0.0)
                Text(
                    String(
                        self.availableColumns[
                            String(self.header[1]) ] ?? "-"
                    )
                )
                    .multilineTextAlignment(.leading).padding(0.0)
                ForEach(1..<self.header.count-1, id: \.self) { i in
                    // TODO: Feilsikring mot å fjerne filnamnet frå visninga
                    HStack {
                        Spacer(minLength: fileListRowMinSpacer)
                        Text(
                            String(
                                self.availableColumns[
                                    String(
                                        self.header[i+1]
                                    )
                                    ] ?? "-"
                            )
                        ).multilineTextAlignment(.trailing).padding(0.0)
                    }
                }
                .padding(.trailing, 4.0)
            }.contextMenu {
                ForEach(self.availableColumns.sorted(by: >), id: \.key) { keyword, readable in
                        Button (action: {
                            print("\(keyword)")
                        if(self.header.contains(keyword)) {
                            self.header.remove(at: self.header.firstIndex(of: keyword)!)
                        }
                        else {
                            self.header.append(keyword)
                        }
                    }) {
                        Text("\(self.availableColumns[keyword]!)")
//                        Text("\(i)")
//                        Text(
//                            String(
//                                self.availableColumns[
//                                    String(self.availableColumns.keys[i])
//                                    ] ?? String(i)
//                            )
//                        )
                    }
                }
            }
            .padding(.leading, 48.0)
            
            /** #The filelist itself
            */
            List(0 ..< self.files.count) { i in
                //    Image("Image.png")
                VStack {
                    FileListRow(filelist: self.$files, index: i, selectedItems: self.$selectKeeper, activeColumns: self.$header)
//                    .contextMenu {
//                        Text("Vis i Finder")
//                }
                Divider()
                }
            }
//            .padding(-8.0)
//            .listStyle(SidebarListStyle())
        }
    }
}

struct FileListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FileList(
                availableColumns: ["filename": "Namn",
                                   "extension": "Format",
                                   "ModifyDate": "Dato", "ModelName": "Modell"],
                header: ["filename", "date", "ModelName"],
                files: [
                    File(dict: ["filename": "File 0", "extension": "CR2", "ModifyDate": "2020:07:12 12:34:56", "ModelName": "Canon EOS 6D"]),
                    File(dict: ["filename": "File 1", "extension": "DNG", "ModifyDate": "2014:08:02 12:34:56", "ModelName": "Hasselblad"])
                ]
            )
        }
    }
}
