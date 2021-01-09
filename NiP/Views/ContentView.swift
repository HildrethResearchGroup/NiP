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
        VStack(alignment: .leading) {
            EquipmentConnectView(stageGroupController: stageGroupController)
            StagePositionView(stageName: "X",stageController: stageGroupController.x)
            //StagePositionView(stageName: "Y", stageController: stageGroupController.y)
            //StagePositionView(stageName: "Z", stageController: stageGroupController.z)
        }
        .fixedSize()
        .padding()
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
