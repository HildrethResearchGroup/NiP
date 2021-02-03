//
//  ManualWaveformView.swift
//  NiP
//
//  Created by Owen Hildreth on 2/3/21.
//

import SwiftUI

struct ManualWaveformView: View {
    @ObservedObject var waveformController: DCWaveformGeneratorController
    
    var body: some View {
        VStack {
            Text("Manual Voltage Control")
                .font(.title)
            EquipmentConnectView(equipmentController: waveformController)
        }
        
    }
}


// MARK: - Preview Provider
struct ManualWaveformView_Previews: PreviewProvider {
    static var previews: some View {
        let userSettings = UserSettings()
        let waveformController = DCWaveformGeneratorController(identifier: userSettings.waveformIdentifier)
            
        ManualWaveformView(waveformController: waveformController)
    }
}
