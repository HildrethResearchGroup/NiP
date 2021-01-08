//
//  StagePositionView.swift
//  NiP
//
//  Created by Dr. Owen Hildreth (Admin) on 1/8/21.
//

import SwiftUI

struct StagePositionView: View {
    let stageController: StageController?
    @ObservedObject var targetDisplacement = NumbersOnly()
    
    var targetDisplacementDouble: Double {
        get {
            guard let doubleValue = Double(targetDisplacement.value) else {return 0.0}
            return doubleValue
        } set {
            targetDisplacement.value = String(newValue)
        }
    }
    
    
    var body: some View {
        HStack {
            Button(action:{
                print("Target Displacement = \(targetDisplacement)")
                stageController?.moveRelative(targetDisplacement: targetDisplacementDouble)
                
            })
            {
                Text("Jog")
            }
            TextField("0.0", text: $targetDisplacement.value)
        }
        
    }
}

struct StagePositionView_Previews: PreviewProvider {
    
    static var previews: some View {
        let controller = StageGroupController()
        let stage = controller.x
        StagePositionView(stageController: stage)
    }
}
