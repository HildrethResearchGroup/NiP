//
//  DiscloosureDetailView.swift
//  Test2
//
//  Created by Owen Hildreth on 3/9/21.
//

import SwiftUI

struct DisclosureDetailView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("Text 1")
                Text("Results 1")
            }
            HStack{
                Text("Text 2")
                Text("Results 2")
            }
        }
    }
}

struct DiscloosureDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DisclosureDetailView()
    }
}
