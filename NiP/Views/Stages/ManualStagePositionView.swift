//
//  ManualStagePositionView.swift
//  NiP
//
//  Created by Owen Hildreth on 2/3/21.
//

import SwiftUI

struct ManualStagePositionView: View {
    let userSettings = UserSettings()
    @ObservedObject var stageGroupController: StageGroupController
    
    var body: some View {
        VStack {
            Text("Manual Stage Control")
                .font(.title)
            stageViews
        }
        .toolbar{
            ToolbarItem(placement: .primaryAction) {
                connectToStageControllerToolbarButton
            }
        }
    }
    
    
    
    private var stageViews: some View {
        VStack(alignment: .leading) {
            StagePositionView(stageName: "X",stageController: stageGroupController.x)
            StagePositionView(stageName: "Y", stageController: stageGroupController.y)
            StagePositionView(stageName: "Z", stageController: stageGroupController.z)
        }
        .fixedSize()
        .padding()
    }
    
    private var connectToStageControllerToolbarButton: some View {
        Button(action:{self.stageGroupController.connectToEquipmentController()})
        {ZStack {
            Toolbar_XPQ8(equipmentState: $stageGroupController.equipmentState)
            }
        }.help("Connect \(stageGroupController.equipmentName)")
    }
}

struct ManualStagePositionView_Previews: PreviewProvider {
    static var previews: some View {
        let stageGroupController  = StageGroupController()
        
        ManualStagePositionView(stageGroupController: stageGroupController)
    }
}
