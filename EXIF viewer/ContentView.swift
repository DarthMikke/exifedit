//
//  ContentView.swift
//  EXIF viewer
//
//  Created by Michal Jan Warecki on 21/07/2020.
//  Copyright © 2020 Michal Jan Warecki. All rights reserved.
//

import SwiftUI
import AppKit.NSOpenPanel

struct EXIFTag: Identifiable {
    var id = UUID()
    var EXIFid: Int
    var type: Int
    var count: Int
    var value: String
}

struct ContentView: View {
    @State var username: String = ""
    var testdata = [
        File(array: ["File 0", "CR2", "2020:07:12 12:34:56 UTC+2", "Canon EOS 6D"]),
        File(array: ["File 1", "DNG", "2014:08:02 12:34:56 UTC+0", "Hasselblad"])
    ]
    
    var EXIFData: [EXIFTag] = [EXIFTag(EXIFid: 0x0110, type: 8, count: 20, value: "Canon EOS 6D"), EXIFTag(EXIFid: 0x0100, type: 1, count: 1, value: "5472"), EXIFTag(EXIFid: 0x0101, type: 1, count: 1, value: "3648")]
    
    var body: some View {
        HStack {
            FileList(header: ["Namn", "Dato", "ModelName"],
                     files: self.testdata
            ) // FileList(headers: ["PropertyA", "PropertyB", …])
            VStack {
                Form {
                    TextField("Nytt namn", text: $username)
                }
                List(EXIFData) { tag in
                    HStack {
                        Text("\(String(exiftags[tag.EXIFid]!))")
                        Spacer()
                        Text("\(tag.value)")
                    }
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

