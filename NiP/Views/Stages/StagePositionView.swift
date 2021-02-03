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
            stagePositionView
            jogMoveView
            absoluteMoveView
            sGammaPickerView
        }
        
    }
    
    
    
    // MARK: - SubViews
    
    private var stagePositionView: some View {
        HStack{
            Text(stageName + ":")
            Text(self.stageController.currentPositionString)
                .frame(minWidth: 60, maxWidth: 60, alignment: .leading)
            
        }
    }
    
    private var jogMoveView: some View {
        HStack {
            // Jog Button
            Button(action:{
                stageController.moveRelative(targetDisplacement: targetDisplacement)
            })
            { Text("Jog") }
                .disabled(stageController.stageState != .idle)
                .help("Jog Stage by \(targetDisplacement) mm")
            
            // Textfield for target displacement
            TextField("-10.00", value: $targetDisplacement, formatter: configureFormatter())
                .frame(minWidth: 80, maxWidth: 80, alignment: .center)
                .padding(.trailing)
        }
    }
    
    private var absoluteMoveView: some View {
        HStack {
            Button(action:{
                stageController.moveAbsolute(toLocation: targetPosition)
            })
            { Text("Move To") }
                .disabled(stageController.stageState != .idle)
                .help("Move Stage to \(targetPosition) mm")
            TextField("-10.00", value: $targetPosition, formatter: configureFormatter())
                .frame(minWidth: 80, maxWidth: 80, alignment: .center)
                .padding(.trailing)
        }
    }
    
    private var sGammaPickerView: some View {
        SGammaPicker(sGammaParameter: $stageController.currentStageSGammaParameters)
            .disabled(stageController.controller == nil)
            .help("Set velocity and acceleration")
    }
    
    func configureFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesSignificantDigits = true
        formatter.minimumSignificantDigits = 3
        formatter.notANumberSymbol = "????"
        
        return formatter
    }
}



// MARK: - Preview Provider
struct StagePositionView_Previews: PreviewProvider {
    
    static var previews: some View {
        let controller = StageGroupController()
        let stage = controller.x
        StagePositionView(stageName: "X", stageController: stage)
    }
}
