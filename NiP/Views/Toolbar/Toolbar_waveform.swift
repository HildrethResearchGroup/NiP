//
//  Toolbar_waveform.swift
//  NiP
//
//  Created by Owen Hildreth on 2/3/21.
//

import SwiftUI

struct Toolbar_waveform: View {
    @Binding var equipmentState: EquipmentState
    
    
    var body: some View {
        ZStack {
            connectionIndicator()
                .offset(x: -16, y: -8)
            Image(systemName: "bolt.fill")
                .offset(x: 6, y: -3)
                .foregroundColor(.yellow)
            Path{ path in
                path.move(to: CGPoint(x: 15.81, y: 0))
                path.addLine(to: CGPoint(x: 15.81, y: 13.45))
                path.addLine(to: CGPoint(x: 31, y: 13.45))
            }
                .stroke(Color.gray, lineWidth: 1)
                .offset(x: -1, y: 5)
            Text("Waveform")
                .font(.system(size: 7))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .offset(x: 0, y: 8)
        }.frame(width: 40, height: 25, alignment: .center)
    }
    
    func connectionIndicator() -> some View {
        let color: Color
        switch equipmentState {
        case .notConnected:
            color = Color.red
        case .busy:
            color = Color.purple
        case .idle:
            color = Color.green
        }
        
        let circleView = Circle()
            .fill(color)
            .frame(width: 7, height: 7)
        
        return circleView
    }
    
    
}

struct Toolbar_waveform_Previews: PreviewProvider {
    static var previews: some View {
        Toolbar_waveform(equipmentState: .constant(.idle))
    }
}
