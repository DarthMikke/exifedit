//
//  ContentViewStructure.swift
//  EXIF viewer
//
//  Created by Michal Jan Warecki on 18/08/2020.
//  Copyright © 2020 Michal Jan Warecki. All rights reserved.
//

import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {
    var filepath: String
    @Published var fileList: Array<File>
    @Published var newFileList: Array<File>
    @Published var exifProperties: Array<String>
    @Published var exifData: Array<EXIFTag>
    @Published var selectedFiles: Set<UUID>
    @Published var selectedNewFiles: Set<UUID>
    
    init(filelist: Array<File>) {
        self.filepath = ""
        self.fileList = filelist
        self.newFileList = filelist
        
        self.selectedFiles = []
        self.selectedNewFiles = []
        
        self.exifProperties = ["filename",
                               "Model",
                               "ModifiedDate",
                               "Author"]
        self.exifData = [EXIFTag(EXIFid: 0x0110,
                                 type: 8,
                                 count: 20,
                                 value: "Canon EOS 6D"),
                         EXIFTag(EXIFid: 0x0100,
                                 type: 1,
                                 count: 1,
                                 value: "5472"),
                         EXIFTag(EXIFid: 0x0101,
                                 type: 1,
                                 count: 1,
                                 value: "3648")]
    }
    
    func loadDirectory() -> Void {
        let openPanel = NSOpenPanel()
        var fileURLs: Array<URL> = []
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = false
        openPanel.begin { (result) in
            if result == .OK {
                // Directory opened
                let fileManager = FileManager.default
        //        let urls = fileManager.enumerator(atPath: String(openPanel.url))
                do {
                    fileURLs = try fileManager.contentsOfDirectory(at: openPanel.url!, includingPropertiesForKeys: nil)
                    for url in fileURLs {
                        print(url)
                    }
                } catch {
                    print("Error while enumerating files \(openPanel.url!): \(error.localizedDescription)")
                }
            } else {
                // User canceled the dialog
            }
        }
    //    return fileURLs
    }
    
    func openFile() {}
    
    func update(property: String, value: String) {
        var i = 0
        repeat {
            print("ContentViewModel: New value of property \(property): '\(value)' for file \(self.newFileList[i].dict["filename"]!)")
            /// TODO: Error handling – vis beskjed om "property" har feil verdi
            /// Den kommenterte linja funkar ikkje
//            self.newFileList[i].changeValue(property: property, value: value)
            self.newFileList[i].dict[property] = unwrapProperty(property: property, newValue: value, withData: self.newFileList[i].dict)
            
            i += 1
        } while (i < self.newFileList.count)
    }
}
