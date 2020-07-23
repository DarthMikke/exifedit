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
    var testdata: Array<File> = [
    File(array: ["File 0", "CR2", "2020:07:12 12:34:56 UTC+2", "Canon EOS 6D"]),
    File(array: ["File 1", "DNG", "2014:08:02 12:34:56 UTC+0", "Hasselblad"])
    ]
    
    var properties = ["Namn", "Kameramodell", "Modifikasjonsdato", "Opphavsperson"]
    @State private var selectedPropertyIndex = 0
    
    var EXIFData: [EXIFTag] = [EXIFTag(EXIFid: 0x0110, type: 8, count: 20, value: "Canon EOS 6D"), EXIFTag(EXIFid: 0x0100, type: 1, count: 1, value: "5472"), EXIFTag(EXIFid: 0x0101, type: 1, count: 1, value: "3648")]
    
    var body: some View {
        HStack {
            FileList(header: ["Namn", "Dato", "ModelName"],
                     files: self.testdata
            )
            VStack {
                Text("EXIF-data")
                List(EXIFData) { tag in
                    VStack {
                        HStack {
                            Text("\(String(exiftags[tag.EXIFid]!))")
                            Spacer()
                            Text("\(tag.value)")
                        }
                        Divider().padding(.top, -8)
                    }
                    .padding(.bottom, -16.0)
                }
                Form {
                    Picker(selection: $selectedPropertyIndex, label: Text("Vel eigenskap du vil endre:")) {
                        ForEach(0..<properties.count) {
                            Text(self.properties[$0])
                        }
                    }
                    TextField("Ny(tt) \(self.properties[selectedPropertyIndex])", text: $username)
                }
                .padding(4.0)
            }
            FileList(header: ["Namn", "Dato", "ModelName"],
                     files: self.testdata
            )
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView(testdata: [
            File(array: ["test 0", "CR2", "2020:07:12 12:34:56 UTC+2", "Canon EOS 6D"]),
            File(array: ["test 1", "DNG", "2014:08:02 12:34:56 UTC+0", "Hasselblad"])
        ])
    }
}

