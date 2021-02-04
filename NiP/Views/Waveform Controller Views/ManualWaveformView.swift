//
//  ManualWaveformView.swift
//  NiP
//
//  Created by Owen Hildreth on 2/3/21.
//

import SwiftUI

struct ManualWaveformView: View {
    let frameWidthForLeftText = CGFloat(200.0)
    let frameWidthForRightInput = CGFloat(80.0)
    @ObservedObject var waveformController: DCWaveformGeneratorController
    @State var voltageOn = false
    
    
    @State var targetVoltage = 0.0
    @State var runTime = 0.0
    
    var body: some View {
        VStack {
            Text("Manual Voltage Control")
                .font(.title)
            connectAndTurnOnView
            HStack {
                TextFieldWithLabel(labelText: "Printhead Voltage [V]", value: $waveformController.targetVoltage, formaterForValue: configureFormatter())
                TextFieldWithLabel(labelText: "Waveform Voltage [V]", value: $waveformController.voltage, formaterForValue: configureFormatter())
            }
            HStack {
                TextFieldWithLabel(labelText: "Run Time [s]", value: $waveformController.runTime, formaterForValue: configureFormatter())
                TextFieldWithLabel(labelText: "Elapsed Time [s]", value: $waveformController.elapsedTime, formaterForValue: configureFormatter())
            }
            

        }
        
    }
    
    
    var connectAndTurnOnView: some View {
        HStack {
            HStack {
                EquipmentConnectView(equipmentController: waveformController)
                
            }
            Toggle("Off/On", isOn: $voltageOn)
                .toggleStyle(SwitchToggleStyle())
                .padding(.leading)
        }
        .toolbar(content: {
            ToolbarItem(placement: .primaryAction) {
                connectToWaveformControllerToolbarButton
            }
        })
    }
    
    private var connectToWaveformControllerToolbarButton: some View {
        Button(action:{self.waveformController.connectToEquipmentController()})
        {ZStack {
            Toolbar_waveform(equipmentState: $waveformController.equipmentState)
            }
        }.help("Connect \(waveformController.equipmentName)")
    }
    
   
    func configureFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesSignificantDigits = true
        formatter.minimumSignificantDigits = 3
        formatter.notANumberSymbol = "????"
        
        return formatter
    }
}


extension HorizontalAlignment {
    struct TextWithFieldAlignmentGuide: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[.firstTextBaseline]
        }
    }

    static let textWithFieldAlignmentGuide = HorizontalAlignment(TextWithFieldAlignmentGuide.self)
}


// MARK: - Preview Provider
struct ManualWaveformView_Previews: PreviewProvider {
    static var previews: some View {
        let userSettings = UserSettings()
        let waveformController = DCWaveformGeneratorController(identifier: userSettings.waveformIdentifier)
            
        Group {
            ManualWaveformView(waveformController: waveformController)
                
        }
    }
}
