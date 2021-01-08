//
//  EquipmentConnectView.swift
//  NiP
//
//  Created by Owen Hildreth on 1/7/21.
//

import SwiftUI

struct EquipmentConnectView: View {
    
    @ObservedObject var stageGroupController: StageGroupController
    
    var body: some View {
        VStack {
            
            HStack {
                connectionIndicator()
                Button(action: {self.stageGroupController.connectToEquipmentController()})
                    { Text("Connect") }.disabled(stageGroupController.connectedToController)
                Text(stageGroupController.equipmentName)
            }.padding()
        }
    }
    
    func connectionIndicator() -> some View {
        let color: Color
        switch stageGroupController.connectedToController {
        case true:
            color = Color.green
        default:
            color = Color.red
        }
        
        let circleView = Circle()
            .fill(color)
            .frame(width: 18, height: 18)
        
        return circleView
    }
    

    
}

struct EquipmentConnectView_Previews: PreviewProvider {
    static var previews: some View {
        let controller = StageGroupController()
        EquipmentConnectView(stageGroupController: controller)
    }
}



