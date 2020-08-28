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
                var filepath:       String
    @Published  var filelist:       Array<File>
    @Published  var newFilelist:    Array<File>
    @Published  var exifProperties: Array<String>
    @Published  var exifData:       Array<EXIFTag>
    @Published  var selectedFiles:  Set<UUID>
    @Published  var selectedNewFiles: Set<UUID>
    @Published  var range:          Array<Int>
    @Published  var newRange:       Array<Int>
                var fileManager:    FileManager
    
    init() {
        self.filepath = ""
        self.filelist = []
        self.newFilelist = []
        
        self.selectedFiles = []
        self.selectedNewFiles = []
        self.range = []
        self.newRange = []
        
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

        self.fileManager = FileManager.default
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
                // Clear selection
                self.selectedFiles = []
                self.selectedNewFiles = []
                
                // Clear filelist
                self.filelist = []
                let fileManager = FileManager.default
                self.filepath = openPanel.url!.absoluteString
                do {
                    fileURLs = try fileManager.contentsOfDirectory(at: openPanel.url!, includingPropertiesForKeys: nil)
                    for url in fileURLs {
                        if(legalExtensions.contains(url.pathExtension)) {
                            print("\(#file) \(#line): \(url.path)")
                            let filename = url.pathComponents[url.pathComponents.count - 1].components(separatedBy: ".")[0]
                            let rawimage = RawImage(filepath: url.path)
                            print("\(#file) \(#line): \(rawimage.tagCount) tags")
                            if rawimage.tagCount != -1 {
                                print("\(#file) \(#line):", filename, url.pathExtension)
                                var dict: Dictionary<String, String>
                                var array: Array<EXIFTag> = []
                                dict = ["filename": filename, "extension": url.pathExtension]
                                for tag in rawimage.exifTags {
                                    if exiftags.keys.contains(tag.EXIFid) {
                                        dict[exiftags[tag.EXIFid]!] = tag.value ?? "-"
                                        array.append(tag)
                                    }
                                }
                                print("\(#file) \(#line): \(array)")
                                self.filelist.append(File(dict: dict, exif: array, index: self.filelist.count))
                            }
                        }
                    }
                    self.newFilelist = self.filelist
                } catch {
                    print("\(#file) \(#line): Error while enumerating files \(openPanel.url!): \(error.localizedDescription)")
                }
            } else {
                // User canceled the dialog
            }
        }
    //    return fileURLs
    }
    
    func openFile() {}
    
    func getExif() -> Array<EXIFTag> {
        let array: Array<EXIFTag> = []
        print("\(#file) \(#line): \(self.selectedFiles.count) files are selected")
        if self.selectedFiles.count == 0 {
            return array
        }
        
        for file in self.filelist {
            if (file.id == self.selectedFiles.first) {
                print ("\(#file) \(#line): Updating EXIF list to:")
                self.exifData = file.exif
                print("\(#file) \(#line): \(file.exif)")
                return file.exif
            }
        }
        return array
    }
    
    func preview(property: String, value: String) {
        var i = 0
        repeat {
            print("\(#file) \(#line): New value of property \(property): '\(value)' for file \(self.newFilelist[i].dict["filename"]!)")
            /// TODO: Error handling – vis beskjed om "property" har feil verdi
            /// Den kommenterte linja funkar ikkje
//            self.newFileList[i].changeValue(property: property, value: value)
            self.newFilelist[i].dict[property] = unwrapProperty(property: property, newValue: value, withData: self.newFilelist[i].dict)
            
            i += 1
        } while (i < self.newFilelist.count)
    }
}
