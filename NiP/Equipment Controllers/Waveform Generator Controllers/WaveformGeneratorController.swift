//
//  WaveformGeneratorController.swift
//  NiP
//
//  Created by Owen Hildreth on 1/18/21.
//

import Foundation




protocol WaveformController: class {
    var outputChannel: UInt { get set }
    static var minimumDelay: UInt32 { get }
    var waveformType: WaveformType {get set}
    
    var dispatchQueue: DispatchQueue? { get }
    
    init?(identifier: String, outputChannel: UInt) throws
    
    func getIdentifier() throws -> String?
    
    func updateImpedence(_ impedenceSetting: ImpedenceSetting) throws
    
    func updateVoltage(_ voltage: Double) throws
    
    func updateWaveform(_ waveform: WaveformType) throws
    
    func runWaveform(for runTime: Double) throws
    
    func stopWaveform() throws
}





