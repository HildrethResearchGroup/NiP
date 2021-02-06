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
    @ObservedObject var printheadController: PrintheadController
    
    init(userSettings: UserSettings) {
        self.userSettings = userSettings
        
        self.stageGroupController  = StageGroupController()
        self.waveformController = DCWaveformGeneratorController(identifier: userSettings.waveformIdentifier)
        self.printheadController = PrintheadController(equipmentName: "Agilent 33500B")
    }
    

    
    var body: some View {
        VStack {
            ManualStagePositionView(stageGroupController: stageGroupController)
            Divider()
            ManualWaveformView(printheadController: printheadController)
                .padding(.bottom)
        }
        
    }//END - body

}






// MARK: - Preview Provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let userSettings = UserSettings()
        ContentView(userSettings: userSettings)
    }
}
