//
//  ContentView.swift
//  NiP
//
//  Created by Owen Hildreth on 12/22/20.
//

import SwiftUI

struct ContentView: View {
    let userSettings: UserSettings
    @ObservedObject var stageGroupController: StageGroupController
    @ObservedObject var waveformController: DCWaveformGeneratorController
    
    init(userSettings: UserSettings) {
        self.userSettings = userSettings
        
        self.stageGroupController  = StageGroupController()
        self.waveformController = DCWaveformGeneratorController(identifier: userSettings.waveformIdentifier)
    }
    

    
    var body: some View {
        VStack {
            ManualStagePositionView(stageGroupController: stageGroupController)
            Divider()
            ManualWaveformView(waveformController: waveformController)
                .padding(.bottom)
        }
        
    }
    
    
    
}






// MARK: - Preview Provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let userSettings = UserSettings()
        ContentView(userSettings: userSettings)
    }
}
