//
//   PrintheadController.swift
//  NiP
//
//  Created by Owen Hildreth on 2/5/21.
//

import Foundation

class PrintheadController: EquipmentController {
    var dcWaveformGeneratorController: DCWaveformGeneratorController? = nil
    
    // MARK: - State Variables
    @Published var targetVoltage = 0.0
    @Published var voltage = 0.0
    @Published var runTime = 0.0
    @Published var elapsedTime = 0.0
    
    
    
    // MARK: - Connection Functions
    override func connectToEquipmentController() {
        let waveformIdentifier = UserSettings().waveformIdentifier
        
        dcWaveformGeneratorController = DCWaveformGeneratorController(identifier: waveformIdentifier, outputChannel: 1)
    }
    
    
    // MARK: - Print Functions
    
    
}
