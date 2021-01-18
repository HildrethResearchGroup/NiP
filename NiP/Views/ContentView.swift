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
            StagePositionView(stageName: "Y", stageController: stageGroupController.y)
            StagePositionView(stageName: "Z", stageController: stageGroupController.z)
        }
        .fixedSize()
        .padding()
        .toolbar{
            ToolbarItem(placement: .primaryAction) {

                Button(action:{self.stageGroupController.connectToEquipmentController()})
                {ZStack {
                    Toolbar_XPQ8(connectedToController: $stageGroupController.connectedToController)
                    //Toolbar_XPQ8()
                    }
                }
            }
            //ToolBars(add: {print("add")}, sort: {print("sort")}, filter: {print("afilterdd")})
        }
    }
    
    
    class customImage: NSImage {
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
