//
//  SwiftUIView.swift
//  EXIF viewer
//
//  Created by Michal Jan Warecki on 29/07/2020.
//  Copyright © 2020 Michal Jan Warecki. All rights reserved.
//

import SwiftUI

struct DateOffsetPicker: View {
    @State var dayOffset: String = ""
    @State var hourOffset: String = ""
    @State var minutesOffset: String = ""
    @State var secondsOffset: String = ""
    @State var plusMinus: Int = 0
    @Binding var offset: String
    
    func updateOffset(changed: Bool) {
        var numOffset: Int
        numOffset = Int(self.secondsOffset) ?? 0
        numOffset += (Int(self.minutesOffset) ?? 0)*60
        numOffset += (Int(self.hourOffset) ?? 0)*3600
        numOffset += (Int(self.dayOffset) ?? 0)*86400
        if (numOffset<0 && self.plusMinus == 1) || (numOffset>0 && self.plusMinus == 0) {
            self.offset = String(numOffset)
            print(self.offset)
        } else {
            self.offset = String(-numOffset)
            print(self.offset)
        }
    }
    
    var body: some View {
        Form {
            HStack(alignment: .center) {
                Picker(selection: $plusMinus, label: Text("Offset med")) {
                    Text("+").tag(0)
                    Text("-").tag(1)
                }
                .pickerStyle(RadioGroupPickerStyle())
                TextField("dd", text: $dayOffset, onEditingChanged: self.updateOffset)
                    .padding(.leading, -2.0)
                    .frame(width: 36.0)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(" ")
                TextField("hh", text: $hourOffset, onEditingChanged: self.updateOffset)
                .padding(.leading, -2.0)
                .frame(width: 36.0)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(":")
                TextField("mm", text: $minutesOffset, onEditingChanged: self.updateOffset)
                .padding(.leading, -2.0)
                .frame(width: 36.0)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(":")
                TextField("ss", text: $secondsOffset, onEditingChanged: self.updateOffset)
                .padding(.leading, -2.0)
                .frame(width: 36.0)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
    }
}

// struct SwiftUIView_Previews: PreviewProvider {
//     @State var offset: String = ""
//     static var previews: some View {
//         DateOffsetPicker(offset: $offset)
//     }
// }
