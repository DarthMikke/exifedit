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
    var EXIFData: [EXIFTag] = [EXIFTag(EXIFid: 0x0110, type: 8, count: 20, value: "Canon EOS 6D"), EXIFTag(EXIFid: 0x0100, type: 1, count: 1, value: "5472"), EXIFTag(EXIFid: 0x0101, type: 1, count: 1, value: "3648")]
        
    var body: some View {
        HStack {
            FileList(header: ["Namn", "Dato", "ModelName"],
                     data: [
                        ["File 0", "CR2", "2020:07:12 12:34:56 UTC+2"],
                        ["File 1", "DNG", "2014:08:02 12:34:56 UTC+0"]
                     ]
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

//    var body: some View {
//        HStack {
//            VStack {
//                Text("Filer:")
//                HStack() {
//                    Text("Gamalt namn")
//                        .fontWeight(.bold).multilineTextAlignment(.leading).padding(.leading, 16.0)
//                    Spacer(minLength: 20)
//                    Text("Nytt namn")
//                        .fontWeight(.bold).multilineTextAlignment(.trailing).padding(.trailing, 26.0)
//                }
//                .padding(.leading, 48.0)
//                List(0 ..< 100) { item in
//                    Image("Image.png")
//                    VStack(alignment: .leading) {
//                        Text("Filnamn")
//                            .fontWeight(.bold)
//                        Text("Format")
//                    }
//                    Spacer(minLength: 20)
//                    Text("Nytt filnamn")
//                        .fontWeight(.bold)
//                }
//            }
//            VStack {
//                Form {
//                    TextField("Nytt namn", text: $username)
//                }
//            }
//        }
//    }
//}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

