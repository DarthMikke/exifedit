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
                        var availableColumns:   Dictionary<String, String>
    @State              var header:             Array<String>
    @EnvironmentObject  var datastore:          ContentViewModel
    @Binding            var selectKeeper:       Set<UUID>
                        var column:             Columns
    // var visibleHeaders: Set<String> = Set(header)
    
    var body : some View {
        VStack {
            Text("Filer:").font(.subheadline).padding(.bottom, 2.0)
            // MARK: Header
            HStack() {
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
                            print("\(#file) \(#line): \(keyword)")
                        if(self.header.contains(keyword)) {
                            self.header.remove(at: self.header.firstIndex(of: keyword)!)
                        }
                        else {
                            self.header.append(keyword)
                        }
                    }) {
                        Text("\(self.availableColumns[keyword]!)")
// TODO: Kontekst-meny
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
            
            // MARK: The filelist itself
            List {
                //    Image("Image.png")
                if self.column == .primary {
                    if self.datastore.filelist.count > 0 {
                        ForEach(self.datastore.filelist, id: \.id) { file in
                            // 0 ..< self.datastore.filelist.count
                            VStack {
                                FileListRow(file: file, column: self.column, activeColumns: self.$header)
                                    .environmentObject(self.datastore)
                                //.contextMenu {
                                //     Text("Vis i Finder")
                                //}
                                Divider()
                            }
                        }
                    } else {
                        Text("Opne ein folder først")
                    }
                    
                }
                else if (self.column == .secondary){
                    if self.datastore.newFilelist.count > 0 {
                        ForEach(self.datastore.filelist, id: \.id) { file in
                            // 0 ..< self.datastore.filelist.count
                            VStack {
                                FileListRow(file: file, column: self.column, activeColumns: self.$header)
                                .environmentObject(self.datastore)
                                //.contextMenu {
                                //     Text("Vis i Finder")
                                //}
                                Divider()
                            }
                        }
                    } else {
                        Text("Opne ein folder først")
                    }
                }
            }
        }
    }
}
