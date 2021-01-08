//
//  ContentView.swift
//  NiP
//
//  Created by Owen Hildreth on 12/22/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var stageGroupController = StageGroupController()
    
    
    var body: some View {
        EquipmentConnectView(stageGroupController: stageGroupController)
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
