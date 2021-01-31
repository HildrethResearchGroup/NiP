//
//  PreferencesPanel.swift
//  NiP
//
//  Created by Owen Hildreth on 1/30/21.
//

import SwiftUI

struct PreferencesPanel: View {
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        VStack{
            waveformSettings()
            xps8Settings()
        }
        .padding()
        
    }
    
    func waveformSettings() -> some View {
        HStack{
            Text("Waveform Generator Identifier:")
            TextField("Identifier", text: $userSettings.waveformIdentifier)
        }
        .frame(minWidth: 200, maxWidth: 500)
    }
    
    func xps8Settings() -> some View {
        HStack {
            Text("XPSQ8 Address:")
            TextField("Address", text: $userSettings.XPSQ8Address)
            Text("XPSQ8 Port:")
            TextField("Port", value: $userSettings.XPSQ8Port, formatter: configureFormatter())
        }
        .frame(minWidth: 200, maxWidth: 500)
    }
    
    func configureFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.minimumIntegerDigits = 4
        formatter.maximumIntegerDigits = 5
        
        return formatter
    }
}

struct PreferencesPanel_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesPanel()
            .environmentObject(UserSettings())
    }
}
