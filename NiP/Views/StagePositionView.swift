//
//  StagePositionView.swift
//  NiP
//
//  Created by Dr. Owen Hildreth (Admin) on 1/8/21.
//

import SwiftUI
import Combine

struct StagePositionView: View {
    let stageName:String
    @ObservedObject var stageController: StageController
    
    @State var targetDisplacement = 0.0
    @State var targetPosition = 0.0
    
    
    var body: some View {
        HStack {
            Text(stageName + ":")
            Text(self.stageController.currentPositionString)
                .frame(minWidth: 60, maxWidth: 60, alignment: .leading)
            Button(action:{
                stageController.moveRelative(targetDisplacement: targetDisplacement)
            })
            { Text("Jog") }
            .disabled(stageController.stageState != .idle)
            TextField("-10.00", value: $targetDisplacement, formatter: configureFormatter())
                .frame(minWidth: 80, maxWidth: 80, alignment: .center)
                .padding(.trailing)
            Button(action:{
                stageController.moveAbsolute(toLocation: targetPosition)
            })
            { Text("Move To") }
                .disabled(stageController.stageState != .idle)
            TextField("-10.00", value: $targetPosition, formatter: configureFormatter())
                .frame(minWidth: 80, maxWidth: 80, alignment: .center)
                .padding(.trailing)
            SGammaPicker(sGammaParameter: $stageController.currentStageSGammaParameters)
                .disabled(stageController.controller == nil)
        }
        
    }
    
    
    func configureFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesSignificantDigits = true
        formatter.minimumSignificantDigits = 3
        formatter.notANumberSymbol = "????"
        
        return formatter
    }
}

struct JogButton: View {
    let stageController: StageController
    var targetDisplacement: Double
    @Binding var areAnyStageMoving: Bool
    
    var body: some View {
        Button(action:{
            stageController.moveRelative(targetDisplacement: targetDisplacement)
        })
        { Text("Jog") }
    }
}


struct StagePositionView_Previews: PreviewProvider {
    
    static var previews: some View {
        let controller = StageGroupController()
        let stage = controller.x
        StagePositionView(stageName: "X", stageController: stage)
    }
}
