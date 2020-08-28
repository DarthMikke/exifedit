//
//  FileStructure.swift
//  EXIF viewer
//
//  Created by Michal Jan Warecki on 18/08/2020.
//  Copyright © 2020 Michal Jan Warecki. All rights reserved.
//

import Foundation

struct EXIFTag: Identifiable {
    var id = UUID()
    var EXIFid: Int
    var type: Int
    var count: Int
    var value: String
}

class File: Identifiable {
    let id: UUID
    @Published var dict:  Dictionary<String, String>
    @Published var exif:  Array<EXIFTag>
    @Published var index: Int
    
    init (dict: Dictionary<String, String>, exif: Array<EXIFTag>, index: Int) {
        self.id = UUID()
        self.dict = dict
        self.exif = exif
        self.index = index
    }
    
    func changeValue(property: String, value: String) {
//        self.dict[property] = unwrapProperty(property: property, newValue: value, withData: self.dict)
        print("\(#file) \(#line): New value of property \(property): \(value)")
        print("\(#file) \(#line): Value rendered as \(unwrapProperty(property: property, newValue: value, withData: self.dict))")
    }
}
