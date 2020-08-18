//
//  functions.swift
//  EXIF viewer
//
//  Created by Michal Jan Warecki on 06/08/2020.
//  Copyright © 2020 Michal Jan Warecki. All rights reserved.
//

import Foundation

func shiftDate(from: String, byOffset: Int) -> String {
    /**
     Shifts date from string _from_ by an offset _byOffset_
     Date formating from http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
     */
    /// TODO: Remove special chars from the string
    let from = from.replacingOccurrences(of: "\u{00}", with: "")
        .trimmingCharacters(in: .whitespacesAndNewlines)
//    print("Shifting date from \(from) by \(Double(byOffset))")
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
    let since: Date = formatter.date(from: from)!
    print("Since date: \(since)")
    let newDate = Date(timeInterval: Double(byOffset), since: since)
    return formatter.string(from: newDate)
}

func unwrapProperty(property: String, newValue: String, withData:Dictionary<String, String>) -> String {
    var unwrapped: String = ""
    var year = "0000"
    var month = "00"
    var day = "00"
    var hour = "00"
    var minutes = "00"
    var seconds = "00"
    
    if property == "ModificationDate" {
        unwrapped = shiftDate(from: withData["ModificationDate"] ?? "0000:00:00 00:00:00",
                               byOffset: Int(newValue) ?? 0)
        return unwrapped
    }
    if property == "filename" {
        unwrapped = newValue
        
        // Regex
        // https://whatdidilearn.info/2018/07/29/how-to-capture-regex-group-values-in-swift.html
        let range = NSRange(location: 0, length: newValue.utf16.count)
        let regex = try! NSRegularExpression(pattern: "%[aA-zZ]*")
        let matches = regex.matches(in: newValue, options: [], range: range)
        
        var i = 0
        if (matches.count > 0) {
        repeat {
            let groups = Range(matches[i].range(at: 0), in: newValue)
            let keyword = String(newValue[groups!]);
            let exifKeywordIndex = keyword.index(keyword.firstIndex(of: "%")!, offsetBy: 1)
            let endIndex = keyword.endIndex
            let exifKeyword = String(keyword[exifKeywordIndex..<endIndex])
            if (withData.keys.contains(exifKeyword)) {
                print(exifKeyword)
                let exifValue = String(withData[exifKeyword]!).trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\u{00}", with: "")
                unwrapped = unwrapped.replacingOccurrences(of: keyword, with: exifValue)
            }
            i += 1
        } while (i < matches.count)}
        
        if (withData.keys.contains("ModifyDate")) {
            let date = withData["ModifyDate"]
            let range = NSRange(location: 0, length: withData["ModifyDate"]!.utf16.count)
            let regex = try! NSRegularExpression(pattern: "([0-9]{4})\\D([0-9]{2})\\D([0-9]{2})\\s([0-9]{2})\\D([0-9]{2})\\D([0-9]{2})")
            let match = regex.firstMatch(in: withData["ModifyDate"]!, options: [], range: range)
            if (match != nil) {
                let yearGroup = Range(match!.range(at: 1), in: date!)
                let monthGroup = Range(match!.range(at: 2), in: date!)
                let dayGroup = Range(match!.range(at: 3), in: date!)
                let hourGroup = Range(match!.range(at: 4), in: date!)
                let minutesGroup = Range(match!.range(at: 5), in: date!)
                let secondsGroup = Range(match!.range(at: 6), in: date!)
                if (yearGroup != nil) {
                    year = String( withData["ModifyDate"]![yearGroup!] )
                }
                if ((monthGroup) != nil) {
                    month = String( withData["ModifyDate"]![monthGroup!] )
                }
                if ((dayGroup) != nil) {
                    day = String( withData["ModifyDate"]![dayGroup!] )
                }
                if ((hourGroup) != nil) {
                    hour = String( withData["ModifyDate"]![hourGroup!] )
                }
                if ((minutesGroup) != nil) {
                    minutes = String( withData["ModifyDate"]![minutesGroup!] )
                }
                if ((secondsGroup) != nil) {
                    seconds = String( withData["ModifyDate"]![secondsGroup!] )
                }
            }
        }
        
        unwrapped = unwrapped.replacingOccurrences(of: "%Y", with: year)
        unwrapped = unwrapped.replacingOccurrences(of: "%M", with: month)
        unwrapped = unwrapped.replacingOccurrences(of: "%d", with: day)
        unwrapped = unwrapped.replacingOccurrences(of: "%h", with: hour)
        unwrapped = unwrapped.replacingOccurrences(of: "%m", with: minutes)
        unwrapped = unwrapped.replacingOccurrences(of: "%s", with: seconds)

        return unwrapped
    }
    
    return unwrapped
}
