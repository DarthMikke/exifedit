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


    // EXIF-vindu
    @State var selectedPropertyIndex = 0
    @State var newProperty: String = ""
    
    var body: some View {
        VStack {
            //Navbar
            HSplitView {
                VStack {
                    FileList(availableColumns: availableColumns,
                             header: header,
                             selectKeeper: self.$viewModel.selectedFiles,
                             column: Columns.primary
                            ).environmentObject(self.viewModel)
                    Form {
                        Button(action: {self.viewModel.loadDirectory()}) {Text("Opne…")}
                    }.padding(2)
                }
                ExifDetailsView(selectedPropertyIndex: self.$selectedPropertyIndex, newProperty: self.$newProperty)
                    .environmentObject(viewModel)
                VStack {
                    FileList(availableColumns: availableColumns,
                             header: header,
                             selectKeeper: self.$viewModel.selectedNewFiles,
                             column: Columns.secondary
                    ).environmentObject(self.viewModel)
                    Form {
                        Button(action: {self.viewModel.savePreview()}) {Text("Lagre…")}
                    }.padding(2)
                }
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

