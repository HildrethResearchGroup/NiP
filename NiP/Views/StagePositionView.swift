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
    
    @State var test = 0.0
    
    
    
    var body: some View {
        HStack {
            stateIndicator()
            Text(stageName + ":")
            Text(self.stageController.currentPositionString)
                .frame(minWidth: 60, maxWidth: 60, alignment: .leading)
            Button(action:{
                stageController.moveRelative(targetDisplacement: test)
            })
            {
                Text("Jog")
            }
            TextField("-10.00", value: $test, formatter: configureFormatter())
                .frame(minWidth: 80, maxWidth: 80, alignment: .center)
        }
        
    }
    
    func configureFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesSignificantDigits = true
        formatter.minimumSignificantDigits = 3
        formatter.notANumberSymbol = "????"
        
        return formatter
    }
    
    func stateIndicator() -> some View {
        let color: Color
        switch stageController.state {
        case .notConnected:
            color = Color.red
        case .idle:
            color = Color.green
        case .moving:
            color = Color.purple
        }
        
        let circleView = Circle()
            .fill(color)
            .frame(width: 10, height: 10)
        
        return circleView
    }

}

struct StagePositionView_Previews: PreviewProvider {
    
    static var previews: some View {
        let controller = StageGroupController()
        let stage = controller.x
        StagePositionView(stageName: "X", stageController: stage)
    }
}
