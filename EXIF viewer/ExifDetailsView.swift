//
//  ExifDetailsView.swift
//  EXIF viewer
//
//  Created by Michal Jan Warecki on 22/08/2020.
//  Copyright © 2020 Michal Jan Warecki. All rights reserved.
//

import SwiftUI

struct ExifDetailsView: View {
    @EnvironmentObject var datastore: ContentViewModel
    @Binding var selectedPropertyIndex: Int
    @Binding var newProperty: String
    
    var body: some View {
        VStack(alignment: .center) {
            // MARK: Oversikt over EXIF-setlar
            Text("EXIF-data")
            List {
                ForEach(self.datastore.exifProperties, id: \.self) { key in
                    VStack {
                        HStack {
                            Text("\(String(key))")
                            Spacer()
                            Text("\(self.datastore.exifDict[key] ?? "–")")
                        }
                        Divider().padding(.top, -8)
                    }
                    .padding(.bottom, -16.0)
                }
            }
            
            // MARK: Redigeringsvindauge
            Form {
                Picker(selection: $selectedPropertyIndex, label: Text("Vel eigenskap du vil endre:")) {
                    ForEach(0..<self.datastore.exifProperties.count, id: \.self) {
                        Text(self.datastore.exifProperties[$0])
                    }
                }
            }
            Form {
                if(self.datastore.exifProperties[selectedPropertyIndex] == "filename") {
                    TextField("Ny(tt) \(self.datastore.exifProperties[selectedPropertyIndex])",
                        text: $newProperty)
                } else if (self.datastore.exifProperties[selectedPropertyIndex] == "ModifyDate") {
                    DateOffsetPicker(offset: $newProperty)
                    //                            DateOffsetPicker(offset: "")
                }
                Button(action: {
                    print("ContentView: \(self.newProperty)")
                    self.datastore.preview(property: self.datastore.exifProperties[self.selectedPropertyIndex], value: self.newProperty)
                    
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
