//
//  ContentView.swift
//  NiP
//
//  Created by Owen Hildreth on 12/22/20.
//

import SwiftUI

struct ContentView: View {
    let userSettings: UserSettings
    @ObservedObject var stageGroupController: StageGroupController
    @ObservedObject var waveformController: DCWaveformGeneratorController
    
    init(userSettings: UserSettings) {
        self.userSettings = userSettings
        
        self.stageGroupController  = StageGroupController()
        self.waveformController = DCWaveformGeneratorController(identifier: userSettings.waveformIdentifier)
    }
    
    
    
    var body: some View {
        VStack(alignment: .leading) {
            EquipmentConnectView(equipmentController: stageGroupController)
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
                }.help("Connect \(stageGroupController.equipmentName)")
            }
            //ToolBars(add: {print("add")}, sort: {print("sort")}, filter: {print("afilterdd")})
        }
    }
}


// MARK: - Preview Provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let userSettings = UserSettings()
        ContentView(userSettings: userSettings)
    }
}
