//
//  FileListView.swift
//  EXIF viewer
//
//  Created by Michal Jan Warecki on 23/07/2020.
//  Copyright © 2020 Michal Jan Warecki. All rights reserved.
//

import Foundation
import SwiftUI

struct FileList: View {
    var header: Array<String>
    var data:   Array<Array<String>>
    
    var body : some View {
        VStack {
            Text("Filer:")
            HStack() {
                Text("Gamalt namn")
                    .fontWeight(.bold).multilineTextAlignment(.leading).padding(.leading, 16.0)
                Spacer(minLength: 20)
                Text("Nytt namn")
                    .fontWeight(.bold).multilineTextAlignment(.trailing).padding(.trailing, 26.0)
            }
            .padding(.leading, 48.0)
            List(0 ..< 100) { item in
                //    Image("Image.png")
                FileListRow(rawImage: ["File \(item)", "CR2"])
            }
        }

    }
}

struct FileListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FileList(header: ["Namn", "Dato", "ModelName"],
                     data: [[""], [""]]//,
                 //    data: [
//                        ["File 0", "CR2", "2020:07:12 12:34:56 UTC+2"],
  //                      ["File 1", "DNG", "2014:08:02 12:34:56 UTC+0"]
    //            ]
            )
        }
    }
}
