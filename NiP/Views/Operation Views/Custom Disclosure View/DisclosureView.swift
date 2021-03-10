//
//  DisclosureView.swift
//  Test2
//
//  Created by Owen Hildreth on 3/9/21.
//

import SwiftUI

struct DisclosureView: View {
    @State var disclosed: Bool = true
    let alignmentOffset: CGFloat = 22.0
    let width:CGFloat = 200.0
    var body: some View {
        GroupBox {
            HStack(alignment: .top) {
                DisclosureIndicator(disclosed: $disclosed)
                VStack(alignment: .leading) {
                    DisclosurePrimaryView()
                    if disclosed {
                        DisclosureDetailView()
                    }
                }
            }.frame(minWidth: width, idealWidth: width, maxWidth: .infinity, alignment: .topLeading)
        }
        
    }
}

struct DisclosureView_Previews: PreviewProvider {
    static var previews: some View {
        DisclosureView()
    }
}
