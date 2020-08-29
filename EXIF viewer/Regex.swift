//
//  Regex.swift
//  EXIF viewer
//
//  Created by Michal Jan Warecki on 29/08/2020.
//  Copyright © 2020 Michal Jan Warecki. All rights reserved.
//

import Foundation

class Regex {
    let pattern:    String
    let regex:      NSRegularExpression?
    let error:      String

    init (pattern: String) {
        self.pattern = pattern
        do {
            self.regex = try NSRegularExpression(pattern: self.pattern, options: [])
            self.error = ""
        } catch {
            self.regex = nil
            self.error = "Couldn't initialize NSRegularExpression with parameter \(self.pattern)"
        }
    }

    func match(in string: String) -> Array<String> {
        let match = self.regex!.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
        var array: Array<String> = []
        if (match == nil) {
            return array
        }
        if match!.numberOfRanges < 1 {
            return array
        }
        
        for i in 1..<match!.numberOfRanges {
            array.append(String(string[Range(match!.range(at: i), in: string)!]))
        }
        return array
    }
}
