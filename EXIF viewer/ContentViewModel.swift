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
    @Published  var exifDict:       Dictionary<String, String>
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
                               "ModifyDate",
                               "ImageWidth",
                               "ImageHeight",
                               "Author"]
        self.exifDict = [exiftags[0x0110] ?? "–": "Canon EOS 6D",
                         exiftags[0x0100] ?? "–": "5472",
                         exiftags[0x0101] ?? "–": "3648"]

        self.fileManager = FileManager.default
    }
    
    fileprivate func addFile(url: URL) {
        if(legalExtensions.contains(url.pathExtension)) {
            print("\(#file) \(#line): \(url.path) is not an allowed file extension")
            return
        }
        print("\(#file) \(#line): \(url.path)")
        let filename = url.pathComponents[url.pathComponents.count - 1].components(separatedBy: ".")[0]
        let rawimage = RawImage(filepath: url.path)
        print("\(#file) \(#line): \(rawimage.tagCount) tags")
        if rawimage.tagCount < 0 {
            // -1 er startverdien
            return
        }
        
        print("\(#file) \(#line):", filename, url.pathExtension)
        var dict: Dictionary<String, String>
        var array: Array<EXIFTag> = []
        dict = ["filename": filename, "extension": url.pathExtension]
        for tag in rawimage.exifTags {
            if exiftags.keys.contains(tag.EXIFid) {
                dict[exiftags[tag.EXIFid]!] = tag.value
                array.append(tag)
            }
        }
        print("\(#file) \(#line): \(array)")
        self.filelist.append(File(dict: dict, exif: array, index: self.filelist.count))
    }
    
    fileprivate func loadDirectoryContents(of filepath: String, url: URL) {
        var fileURLs: Array<URL> = []
        
        // Clear selection
        self.selectedFiles = []
        self.selectedNewFiles = []
        
        // Clear filelist
        self.filelist = []
        let fileManager = FileManager.default
        self.filepath = filepath
        do {
            fileURLs = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            for url in fileURLs {
                self.addFile(url: url)
            }
            self.newFilelist = self.filelist
        } catch {
            print("\(#file) \(#line): Error while enumerating files \(url): \(error.localizedDescription)")
        }
    }
    
    func loadDirectory() -> Void {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = false
        openPanel.begin { (result) in
            if result == .OK {
                // Directory opened
                self.loadDirectoryContents(of: openPanel.url!.absoluteString, url: openPanel.url!)
            } else {
                // User canceled the dialog
                return
            }
        }
    }
    
    func openFile() {}
    
    func getExif() -> Void {
        print("\(#file) \(#line): \(self.selectedFiles.count) files are selected")
        if self.selectedFiles.count == 0 {
            return
        }
        
        for file in self.filelist {
            if (file.id == self.selectedFiles.first) {
                print ("\(#file) \(#line): Updating EXIF list to:")
                print("\(#file) \(#line): \(file.exif)")
                self.exifProperties = ["filename"]
                for tag in file.exif {
                    self.exifProperties.append(exiftags[tag.EXIFid] ?? "–")
                    self.exifDict[exiftags[tag.EXIFid] ?? "–"] = tag.value
                }
                return
            }
        }
        return
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
