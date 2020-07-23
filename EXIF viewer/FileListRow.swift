//
//  FileListRow.swift
//  EXIF viewer
//
//  Created by Michal Jan Warecki on 23/07/2020.
//  Copyright © 2020 Michal Jan Warecki. All rights reserved.
//

import Foundation
import SwiftUI

struct FileListRow : View {
    var rawImage: Array<String>
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(self.rawImage[0])
                    .fontWeight(.bold)
                Text(self.rawImage[1])
            }
            Spacer(minLength: 20)
            Text("Nytt filnamn")
                .fontWeight(.bold)
        }
    }
}

struct FileListRow_Previews: PreviewProvider {
    static var previews: some View {
        FileListRow(rawImage: ["test", "CR2"])
    }
}
