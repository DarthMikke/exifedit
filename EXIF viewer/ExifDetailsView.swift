//
//  ExifDetailsView.swift
//  EXIF viewer
//
//  Created by Michal Jan Warecki on 22/08/2020.
//  Copyright © 2020 Michal Jan Warecki. All rights reserved.
//

import SwiftUI

struct ExifDetailsView: View {
    @EnvironmentObject var viewModel: ContentViewModel
    @Binding var selectedPropertyIndex: Int
    @Binding var newProperty: String
    
    var body: some View {
        VStack(alignment: .center) {
            // MARK: Oversikt over EXIF-setlar
            Text("EXIF-data")
            List {
                ForEach(self.viewModel.exifData) { tag in
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
            }
            
            // MARK: Redigeringsvindauge
            Form {
                Picker(selection: $selectedPropertyIndex, label: Text("Vel eigenskap du vil endre:")) {
                    ForEach(0..<self.viewModel.exifProperties.count, id: \.self) {
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
                    self.viewModel.preview(property: self.viewModel.exifProperties[self.selectedPropertyIndex], value: self.newProperty)
                    
                }) {Text("Forhandsvis →")}
            }
            .padding(4.0)
            .listStyle(SidebarListStyle())
        }//.background(Color(red: 0.925, green: 0.925, blue: 0.925, opacity: 0.6))
    }
}

//struct ExifDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExifDetailsView()
//    }
//}
