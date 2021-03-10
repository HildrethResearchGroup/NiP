//
//  DisclosureIndicator.swift
//  Test2
//
//  Created by Owen Hildreth on 3/9/21.
//

import SwiftUI

struct DisclosureIndicator: View {
    @Binding var disclosed: Bool
    let size:CGFloat = 15.0
    
    
    var body: some View {
        Button(action: {
            withAnimation(){
                disclosed.toggle()
            }
        }, label: {
            Image(systemName: disclosed ? "chevron.right" : "chevron.down")
        })
        .buttonStyle(BorderlessButtonStyle())
        .frame(width: size, height: size, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        
        
    }
}

struct DisclosureIndicator_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DisclosureIndicator(disclosed: .constant(true))
            DisclosureIndicator(disclosed: .constant(false))
        }
    }
}
