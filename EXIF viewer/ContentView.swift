//
//  ContentView.swift
//  EXIF viewer
//
//  Created by Michal Jan Warecki on 21/07/2020.
//  Copyright © 2020 Michal Jan Warecki. All rights reserved.
//

import SwiftUI


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
    
    init(debug: Bool = false) {
        var filelist: Array<File>
        if debug {
            filelist = self.testdata
        } else {
            filelist = []
        }
        self.viewModel = ContentViewModel(filelist: filelist)
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
                        Button(action: {self.viewModel.loadDirectory()}) {Text("Opne…")}
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
        ContentView(debug: true)
    }
}

