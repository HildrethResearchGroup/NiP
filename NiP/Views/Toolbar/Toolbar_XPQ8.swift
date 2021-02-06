//
//  Toolbar_XPQ8.swift
//  NiP
//
//  Created by Owen Hildreth on 1/17/21.
//

import SwiftUI

struct Toolbar_XPQ8: View {
    //@Binding var connectedToController: Bool
    @Binding var equipmentState: EquipmentState
    //var connectedToController: Bool = true
    
    var body: some View {
        ZStack {
            connectionIndicator()
                .offset(x: -16, y: -8)
            Path{ path in
                path.move(to: CGPoint(x: 15.81, y: 0))
                path.addLine(to: CGPoint(x: 15.81, y: 13.45))
                path.addLine(to: CGPoint(x: 31, y: 13.45))
            }
                .stroke(Color.gray, lineWidth: 1)
            Path{ path in
                path.move(to: CGPoint(x: 15.81, y: 13.45))
                path.addLine(to: CGPoint(x: 11, y: 20))
            }
                .stroke(Color.gray, lineWidth: 1)
            Text("XPSQ8")
                .font(.system(size: 8))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .offset(x: 8, y: 8)
        }.frame(width: 40, height: 25, alignment: .center)
        
    }// END: body
    
    
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


// MARK: - Preview Provider
/**
struct Toolbar_XPQ8_Previews: PreviewProvider {
    
    
    static var previews: some View {
        Toolbar_XPQ8()
    }
}
 */
 

