//
//  CustomTextField.swift
//  NiP
//
//  Created by Owen Hildreth on 2/3/21.
//

import SwiftUI

struct TextFieldWithLabel: View {
    var labelText: String
    @Binding var value: Double
    var formaterForValue: NumberFormatter
    
    var labelTextWidth = CGFloat(140.0)
    var valueTextWidth = CGFloat(80.0)
    
    var body: some View {
        HStack {
            Text(labelText)
                .frame(minWidth: labelTextWidth, maxWidth: labelTextWidth, alignment: .trailing)
            TextField("0.00", value: $value, formatter:formaterForValue)
                .frame(minWidth: valueTextWidth, maxWidth: valueTextWidth, alignment: .leading)
                //.padding(.leading)
        }
    }
}

struct TextFieldWithLabel_Previews: PreviewProvider {
    static var previews: some View {
        let labelText = "Some thing [s]"
        
        TextFieldWithLabel(labelText: labelText, value: .constant(100.0), formaterForValue: NumberFormatter())
    }
}
