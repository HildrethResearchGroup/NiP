//
//  StagePositionView.swift
//  NiP
//
//  Created by Dr. Owen Hildreth (Admin) on 1/8/21.
//

import SwiftUI

struct StagePositionView: View {
    let stageName:String
    let stageController: StageController?
    
    @State var test = 0.0
    
    
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
            Text(stageName + ":")
            Text(self.currentPosition())
            Button(action:{
                print("Target Displacement = \(targetDisplacement)")
                stageController?.moveRelative(targetDisplacement: targetDisplacementDouble)
            })
            {
                Text("Jog")
            }
            TextField("0.00", value: $test, formatter: configureFormatter())
        }
        
    }
    
    func configureFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesSignificantDigits = true
        formatter.minimumSignificantDigits = 3
        formatter.notANumberSymbol = "????"
        
        return formatter
    }
    
    func currentPosition() -> String {
        let errorValue = "??.??"
        let formatter = configureFormatter()
        formatter.minimumSignificantDigits = 5
        formatter.maximumSignificantDigits = 5
        
        guard let position = self.stageController?.currentPosition else {return errorValue}
        guard let positionAsString = formatter.string(from: NSNumber(value: position)) else {return errorValue}
        
        return positionAsString
    }
}

struct StagePositionView_Previews: PreviewProvider {
    
    static var previews: some View {
        let controller = StageGroupController()
        let stage = controller.x
        StagePositionView(stageName: "X", stageController: stage)
    }
}
