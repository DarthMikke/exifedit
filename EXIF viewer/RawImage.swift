//
//  EXIF.swift
//  EXIF-cli
//
//  Created by Michal Jan Warecki on 21/07/2020.
//  Copyright © 2020 Michal Jan Warecki. All rights reserved.
//
import Foundation

let LE = 0
let BE = 1

func readStream(stream: InputStream, count: Int) -> Array<UInt8> {
    var array : Array<UInt8> = []
    let bufferPointer = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(count))
    let bytesRead = stream.read(bufferPointer, maxLength:count)
    //    array.append(Int(bufferPointer[0..<count]))
    
    if bytesRead == -1 {
        print("Read error")
        return array
    }
    for i in 0 ..< bytesRead {
        array.append(bufferPointer[i])
    }
    
    return array
}

class RawImage {
    var filepath: String
    var array : Array<UInt8> = []
    
    var endianness: Int
    var tiffOffset: Int
    var ifd0Offset: Int
    
    var tagCount: Int
    var EXIFTags: Dictionary<Int, Any>
    
    func toUInt16(array : ArraySlice<UInt8>) -> UInt16 {
        if (self.endianness == LE) {
            return UInt16(littleEndian: array.withUnsafeBufferPointer {
                ($0.baseAddress!.withMemoryRebound(to: UInt16.self, capacity: 1) { $0 })
            }.pointee)
        } else if (self.endianness == BE) {
            return UInt16(bigEndian: array.withUnsafeBufferPointer {
                ($0.baseAddress!.withMemoryRebound(to: UInt16.self, capacity: 1) { $0 })
            }.pointee)
        }
        return 0
    }
    
    func toUInt32(array : ArraySlice<UInt8>) -> UInt32 {
        if (self.endianness == LE) {
            return UInt32(littleEndian: array.withUnsafeBufferPointer {
                ($0.baseAddress!.withMemoryRebound(to: UInt32.self, capacity: 1) { $0 })
            }.pointee)
        } else if (self.endianness == BE) {
            return UInt32(bigEndian: array.withUnsafeBufferPointer {
                ($0.baseAddress!.withMemoryRebound(to: UInt32.self, capacity: 1) { $0 })
            }.pointee)
        }
        return 0
    }
    
    func toInt16(array : ArraySlice<UInt8>) -> Int16 {
        if (self.endianness == LE) {
            return Int16(littleEndian: array.withUnsafeBufferPointer {
                ($0.baseAddress!.withMemoryRebound(to: Int16.self, capacity: 1) { $0 })
            }.pointee)
        } else if (self.endianness == BE) {
            return Int16(bigEndian: array.withUnsafeBufferPointer {
                ($0.baseAddress!.withMemoryRebound(to: Int16.self, capacity: 1) { $0 })
            }.pointee)
        }
        return 0
    }
    
    func toInt32(array : ArraySlice<UInt8>) -> Int32 {
        if (self.endianness == LE) {
            return Int32(littleEndian: array.withUnsafeBufferPointer {
                ($0.baseAddress!.withMemoryRebound(to: Int32.self, capacity: 1) { $0 })
            }.pointee)
        } else if (self.endianness == BE) {
            return Int32(bigEndian: array.withUnsafeBufferPointer {
                ($0.baseAddress!.withMemoryRebound(to: Int32.self, capacity: 1) { $0 })
            }.pointee)
        }
        return 0
    }
    
    // TODO: Support EXIF formats (U)Ratio, (U)Byteseq, Single and Double
    
    init(filepath: String) {
        self.filepath = filepath
        self.array = []
        
        self.endianness = -1
        self.tiffOffset = -1
        self.ifd0Offset = -1
        
        self.tagCount = -1
        self.EXIFTags = [:]
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: self.filepath) {
            print("RawImage: File \(self.filepath) does not exist")
            return
        }
        guard let stream = InputStream(fileAtPath: filepath) else {
          print("ERROR OPENING FILE")
          return
        }
        
        // MARK: Find TIFF header and endianness
        stream.open()
        self.tiffOffset = 0
        let chunkSize = 1024*32
        
        var tiffFound = false
        var endianness_string : String
        repeat {
            let touple = readStream(stream: stream, count: 2)
            self.array.append(contentsOf: touple)
            endianness_string = String(bytes: touple, encoding: .ascii)!
            
            if (endianness_string == "II") || (endianness_string == "MM") {
                tiffFound = true
                if (endianness_string == "MM") {
                    self.endianness = BE
                } else  {
                    self.endianness = LE
                }
                break
            }
            
            self.tiffOffset += 2
            
        } while (tiffFound == false)
        
        print("TIFF header starts at byte #\(self.tiffOffset)")
        print("Endianness: \(endianness_string)")
        
        // MARK: Load bytes to array
        self.array.append(contentsOf: readStream(stream: stream, count: chunkSize))
        stream.close()
        print("Loaded \(self.array.count) bytes to array.")

        // MARK: Find IFD0 offset
        self.ifd0Offset = Int(self.toUInt16(array: self.array[self.tiffOffset+4...self.tiffOffset+7]))
        print("IFD0 offset: \(self.ifd0Offset)")
        
        // MARK: Search for tags
        self.tagCount = Int(self.toUInt16(array: self.array[self.ifd0Offset...self.ifd0Offset+1]))
        print("\(self.tagCount) items")
        var i = self.tiffOffset + self.ifd0Offset + 2
        var j = 0
        repeat {
            let tag: Int = Int(toUInt16(array: self.array[i...i+1]))
            let type: Int = Int(toUInt16(array: self.array[i+2...i+3]))
            let count: UInt32 = toUInt32(array: self.array[i+4...i+7])
            let value: UInt32 = toUInt32(array: self.array[i+8...i+11])
            // print("\(tag) \(type) \(count) \(value)")
            j += 1
            i += 12
            if (pointers.contains(Int(type))) {
                /// #Go to pointer
                let value = self.array[Int(value)...Int(value+count-1)]
                if (Int(type) == STRING) {
                    var newvalue: String
                    newvalue = String(bytes: value, encoding: .ascii) ?? "Wrong value"
                    EXIFTags[tag] = newvalue
                } else {
                    EXIFTags[tag] = value
                }
            } else {
                EXIFTags[tag] = value
            }
        }
        while (j < tagCount)
    }
    
    func rename(newfilename: String) -> Int {
        return -1
    }
    
}
