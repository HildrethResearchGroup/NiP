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
    @ObservedObject var stageController: StageController?
    
    @State var test = 0.0
    
    
    
    var body: some View {
        HStack {
            Text(stageName + ":")
            Text(self.stageController?.currentPositionString ?? "Nothing")
            Button(action:{
                //print("Target Displacement = \(targetDisplacement)")
                print("Target Displacement = \(test)")
                stageController?.moveRelative(targetDisplacement: test)
            })
            {
                Text("Jog")
            }
            TextField("-10.00", value: $test, formatter: configureFormatter())
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

struct StagePositionView_Previews: PreviewProvider {
    
    static var previews: some View {
        let controller = StageGroupController()
        let stage = controller.x
        StagePositionView(stageName: "X", stageController: stage)
    }
}
