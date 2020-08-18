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
    @Published var selectedFiles: Set<UUID>
    @Published var selectedNewFiles: Set<UUID>
    
    init(filelist: Array<File>) {
        self.filepath = ""
        self.fileList = filelist
        self.newFileList = filelist
        
        self.selectedFiles = []
        self.selectedNewFiles = []
        
        self.exifProperties = ["filename",
                               "Model",
                               "ModifiedDate",
                               "Author"]
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
    }
    
    func update(property: String, value: String) {
        var i = 0
        repeat {
            print("ContentViewModel: New value of property \(property): '\(value)' for file \(self.newFileList[i].dict["filename"]!)")
            /// TODO: Error handling – vis beskjed om "property" har feil verdi
            /// Den kommenterte linja funkar ikkje
//            self.newFileList[i].changeValue(property: property, value: value)
            self.newFileList[i].dict[property] = unwrapProperty(property: property, newValue: value, withData: self.newFileList[i].dict)
            
            i += 1
        } while (i < self.newFileList.count)
    }
}

struct ContentView: View {
    var testdata: Array<File> = [
        File(dict: [
            "filename": "File 0",
            "extension": "CR2",
            "ModifyDate": "2020:07:12 12:34:56",
            "Model": "Canon EOS 6D"]),
        File(dict: [
            "filename": "File 1",
            "extension": "DNG",
            "ModifyDate": "2014:08:02 12:34:56",
            "Model": "Hasselblad"])
    ]
    @ObservedObject var viewModel: ContentViewModel
    
    init() {
        self.viewModel = ContentViewModel(filelist: self.testdata)
    }
    
    var availableColumns = ["filename": "Namn","extension": "Format", "ModifyDate": "Dato", "Model": "Modell"]
    var header = ["filename", "ModifyDate", "Model"]

    // EXIF-vindu
    @State private var selectedPropertyIndex = 0
    @State var newProperty: String = ""
    
    var body: some View {
        VStack {
            //Navbar
            HSplitView {
                VStack {
                    FileList(availableColumns: self.availableColumns,
                             header: self.header,
                             files: self.viewModel.fileList
                    )
                    Form {
                        Button(action: {}) {Text("Opne…")}
                    }.padding(2)
                }
                VStack(alignment: .center) {
                    Text("EXIF-data")
                    List(self.viewModel.exifData) { tag in
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
                            ForEach(0..<self.viewModel.exifProperties.count) {
                                Text(self.viewModel.exifProperties[$0])
                            }
                        }
                    }
                    Form {
                        if(self.viewModel.exifProperties[selectedPropertyIndex] == "filename") {
                            TextField("Ny(tt) \(self.viewModel.exifProperties[selectedPropertyIndex])",
                                text: $newProperty)
                        } else if (self.viewModel.exifProperties[selectedPropertyIndex] == "ModifyDate") {
                            DateOffsetPicker(offset: $newProperty)
//                            DateOffsetPicker(offset: "")
                        }
                        Button(action: {
                            print("ContentView: \(self.newProperty)")
                            self.viewModel.update(property: self.viewModel.exifProperties[self.selectedPropertyIndex], value: self.newProperty)
                            
                        }) {Text("Forhandsvis →")}
                    }
                    .padding(4.0)
                    .listStyle(SidebarListStyle())
                }//.background(Color(red: 0.925, green: 0.925, blue: 0.925, opacity: 0.6))
                FileList(availableColumns: self.availableColumns,
                         header: self.header,
                         files: self.viewModel.newFileList
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

