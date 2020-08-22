//
//  ContentView.swift
//  EXIF viewer
//
//  Created by Michal Jan Warecki on 21/07/2020.
//  Copyright © 2020 Michal Jan Warecki. All rights reserved.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    
    var availableColumns = ["filename": "Namn","extension": "Format", "ModifyDate": "Dato", "Model": "Modell"]
    var header = ["filename", "ModifyDate", "Model"]

    // EXIF-vindu
    @State var selectedPropertyIndex = 0
    @State var newProperty: String = ""
    
    var body: some View {
        VStack {
            //Navbar
            HSplitView {
                VStack {
                    FileList(availableColumns: self.availableColumns,
                             header: self.header,
                             column: Columns.primary
                            ).environmentObject(self.viewModel)
                    Form {
                        Button(action: {self.viewModel.loadDirectory()}) {Text("Opne…")}
                    }.padding(2)
                }
                ExifDetailsView(selectedPropertyIndex: self.$selectedPropertyIndex, newProperty: self.$newProperty)
                    .environmentObject(viewModel)
                FileList(availableColumns: self.availableColumns,
                         header: self.header,
                         column: Columns.secondary
                ).environmentObject(self.viewModel)
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

