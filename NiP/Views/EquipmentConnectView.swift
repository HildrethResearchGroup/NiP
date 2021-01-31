//
//  EquipmentConnectView.swift
//  NiP
//
//  Created by Owen Hildreth on 1/7/21.
//

import SwiftUI

struct EquipmentConnectView: View {
    
    @ObservedObject var equipmentController: EquipmentController
    
    var body: some View {
        VStack {
            HStack {
                connectionIndicator()
                Button(action: {self.equipmentController.connectToEquipmentController()})
                    { Text("Connect") }.disabled(equipmentController.connectedToController)
                    .help("Connect \(equipmentController.equipmentName)")
                Text(equipmentController.equipmentName)
            }
        }
    }
    
    /**
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
 */
    
    func connectionIndicator() -> some View {
        let color: Color
        switch equipmentController.equipmentState {
        case .notConnected:
            color = Color.red
        case .busy:
            color = Color.purple
        case .idle:
            color = Color.green
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
        EquipmentConnectView(equipmentController: controller)
    }
}



