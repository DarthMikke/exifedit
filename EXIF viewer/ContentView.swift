//
//  ContentView.swift
//  EXIF viewer
//
//  Created by Michal Jan Warecki on 21/07/2020.
//  Copyright © 2020 Michal Jan Warecki. All rights reserved.
//

import SwiftUI
// import AppKit.NSOpenPanel

//func listDirectory(filepath: String) -> Array<String> {
//    var filelist : Array<String> = []
//    let fileManager = FileManager.default
//    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//    do {
//        filelist = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
//        // process files
//    } catch {
//        print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
//    }
//
//    return filelist
//}

struct EXIFTag: Identifiable {
    var id = UUID()
    var EXIFid: Int
    var type: Int
    var count: Int
    var value: String
}

class ContentViewModel: ObservableObject {
    var filepath: String
    @Published var fileList: Array<File>
    @Published var newFileList: Array<File>
    @Published var exifProperties: Array<String>
    @Published var exifData: Array<EXIFTag>
    @Published var newProperty: String
    
    init(filelist: Array<File>) {
        self.filepath = ""
        self.fileList = filelist
        self.newFileList = filelist
        self.exifProperties = ["Namn",
                               "Kameramodell",
                               "Modifikasjonsdato",
                               "Opphavsperson"]
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
        self.newProperty = ""
    }
    
    func update(property: String) {
        var i = 0
        repeat {
            self.newFileList[i].dict[property] = self.newProperty
            i += 1
        } while (i < self.newFileList.count)
    }
}

struct ContentView: View {
    var testdata: Array<File> = [
        File(dict: [
            "filename": "File 0",
            "extension": "CR2",
            "date": "2020:07:12 12:34:56 UTC+2",
            "ModelName": "Canon EOS 6D"]),
        File(dict: [
            "filename": "File 1",
            "extension": "DNG",
            "date": "2014:08:02 12:34:56 UTC+0",
            "ModelName": "Hasselblad"])
    ]
    var newFileList: Array<File> = [
        File(dict: [
            "filename": "File 0",
            "extension": "CR2",
            "date": "2020:07:12 12:34:56 UTC+2",
            "ModelName": "Canon EOS 6D"]),
        File(dict: [
            "filename": "File 1",
            "extension": "DNG",
            "date": "2014:08:02 12:34:56 UTC+0",
            "ModelName": "Hasselblad"])
    ]
    @ObservedObject var viewModel: ContentViewModel
    
    init() {
        self.viewModel = ContentViewModel(filelist: self.testdata)
    }
    
    var availableColumns = ["filename": "Namn","extension": "Format", "date": "Dato", "ModelName": "Modell"]
    var header = ["filename", "date", "ModelName"]

    // EXIF-vindu
    var properties = ["Namn", "Kameramodell", "Modifikasjonsdato", "Opphavsperson"]
    @State private var selectedPropertyIndex = 0
    var EXIFData: [EXIFTag] = [EXIFTag(EXIFid: 0x0110, type: 8, count: 20, value: "Canon EOS 6D"), EXIFTag(EXIFid: 0x0100, type: 1, count: 1, value: "5472"), EXIFTag(EXIFid: 0x0101, type: 1, count: 1, value: "3648")]
    @State var newProperty: String = ""
    
    
    func changeName() {
        print(self.newProperty)
    }
    
    var body: some View {
        VStack {
            //Navbar
            HStack {
                FileList(availableColumns: self.availableColumns,
                         header: self.header,
                         files: self.testdata
                )
                VStack(alignment: .center) {
                    Text("EXIF-data")
                    List(self.EXIFData) { tag in
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
//                    .listStyle(SidebarListStyle())
                    Form {
                        Picker(selection: $selectedPropertyIndex, label: Text("Vel eigenskap du vil endre:")) {
                            ForEach(0..<properties.count) {
                                Text(self.properties[$0])
                            }
                        }
                    }
                    Form {
                        if(self.properties[selectedPropertyIndex] == "Namn") {
                            TextField("Ny(tt) \(self.properties[selectedPropertyIndex])",
                                text: $newProperty)
                        } else if (self.properties[selectedPropertyIndex] == "Modifikasjonsdato") {
                            DateOffsetPicker(offset: $newProperty)
//                            DateOffsetPicker(offset: "")
                        }
                        Button(action: changeName) {Text("Forhandsvis →")}
                    }
                    .padding(4.0)
                    .listStyle(SidebarListStyle())
                }//.background(Color(red: 0.925, green: 0.925, blue: 0.925, opacity: 0.6))
                FileList(availableColumns: self.availableColumns,
                         header: self.header,
                         files: self.newFileList
                )
            }
            .padding(0.0)
        }
        .padding(0.0)
    }
}


struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}

