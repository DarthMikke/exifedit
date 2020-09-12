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
    @Published  var property:       String
                var fileManager:    FileManager
    
    init() {
        self.filepath = ""
        self.filelist = []
        self.newFilelist = []
        
        self.selectedFiles = []
        self.selectedNewFiles = []
        self.range = []
        self.newRange = []
        
        self.property = ""
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
        if !(legalExtensions.contains(url.pathExtension)) {
            print("\(#file) \(#line): Extension \(url.pathExtension) is not allowed (\(url.path)).")
            return
        }
        print("\(#file) \(#line): \(url.path)")
        
        var dict: Dictionary<String, String>
        let filename = url.pathComponents[url.pathComponents.count - 1].components(separatedBy: ".")[0]
        let exifpath = Bundle.main.path(forResource: "exiftool", ofType: "")
        dict = ["filename": filename, "extension": url.pathExtension, "path": url.path]
        let pattern = "^-([aA-zZ|0-9]+)=(.*)$"
        
        let output = runCommand(cmd: exifpath!, args: url.path, "-args").output
        for line in output {
            /// TODO: Her kan ei linje vera ein feil kasta av exiftool. Feilane må hentast ut og informerast om.
            let regex = Regex(pattern: pattern)
            let match = regex.match(in: line)
            if match.count > 0 {
                dict[match[0]] = match[1]
            }
        }
        print("\(#file) \(#line):", filename, url.pathExtension)
        print("\(#file) \(#line): \(dict.keys.count) tags")
        if dict.keys.count == 0 {
            return
        }
        self.filelist.append(File(dict: dict, index: self.filelist.count))
        self.newFilelist.append(File(dict: dict, index: self.newFilelist.count))
    }
    
    fileprivate func loadDirectoryContents(of filepath: String, url: URL) {
        var fileURLs: Array<URL> = []
        
        // Clear selection
        self.selectedFiles = []
        self.selectedNewFiles = []
        
        // Clear filelist
        self.filelist = []
        self.newFilelist = []
        let fileManager = FileManager.default
        self.filepath = filepath
        do {
            fileURLs = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            for url in fileURLs {
                self.addFile(url: url)
            }
//            self.newFilelist = self.filelist
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
    
    func savePreview() {
        let exifpath = Bundle.main.path(forResource: "exiftool", ofType: "")!
        if self.property == "" {
            print("\(#file) \(#line): No property to change")
            return
        }
        print("\(#file) \(#line): Changing property", self.property)
        for file in self.newFilelist {
            let oldname = self.filelist[file.index].dict["path"]!
            let newname = file.dict[self.property]! // treng utviding på slutten og fullstendig path
            print("exiftool \"-filename=\(newname).%e\" \"\(oldname)\"")
            
            // exiftool -filename="2020:07:15 00:55:46 Canon EOS 6D.%e" ./test.CR2
            print(runCommand(cmd: exifpath, args: "-filename=\(newname).%e", oldname).output)
        }
    }
    
    func getExif() -> Void {
        print("\(#file) \(#line): \(self.selectedFiles.count) files are selected")
        if self.selectedFiles.count == 0 {
            return
        }
        
        for file in self.filelist {
            if (file.id == self.selectedFiles.first) {
                self.exifProperties = ["filename"]
                for (exifTag, value) in file.dict {
                    self.exifProperties.append(exifTag)
                    self.exifDict[exifTag] = value
                }
                return
            }
        }
        return
    }
    
    func preview(property: String, value: String) {
        self.property = property
        var i = 0
        repeat {
            print("\(#file) \(#line): New value of property \(property): '\(value)' for file \(self.newFilelist[i].dict["filename"]!)")
            /// TODO: Error handling – vis beskjed om "property" har feil verdi
            /// Den kommenterte linja funkar ikkje
//            self.newFileList[i].changeValue(property: property, value: value)
            
            if property == "filename" {
                let newname = unwrapProperty(property: property, newValue: value, withData: self.newFilelist[i].dict)
                
                var counter = 0
                for file in self.newFilelist {
                    if (file.dict["filename"] == newname + " \(counter)" && counter > 0) ||
                        (file.dict["filename"] == newname && counter == 0) {
                        counter += 1
                    }
                }
                let appendix: String
                if counter == 0 { appendix = "" }
                else { appendix = " \(counter)" }
                self.newFilelist[i].dict[property] = newname + appendix
            }
            
            i += 1
        } while (i < self.newFilelist.count)
        self.newFilelist.append(File(dict: [:], index: self.newFilelist.count))
        self.newFilelist.remove(at: self.newFilelist.count - 1)
    }
}
