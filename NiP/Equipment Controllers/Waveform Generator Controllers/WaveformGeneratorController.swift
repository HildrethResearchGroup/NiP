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


/**
   Use to set the impedence of the instrument
   - **standard**: Set the instrument's impedence to a standard 50Ω.  This is often used if you are driving a standard circuit.
   - **infinite**: Infinite Impedence is used when connecting directly to other high impedence instruments.  If this setting isn't used, then the high impedence instruments will see 2⨉ the desired voltage
   - **finite(UInt)**: Set impedence to an arbitrary postive value
   
    ### Usage Example: ###
    
    ````
    setImpedence(.infinite)
    
    setImpedence(.standard)
    
    setImpedence(.finite(250))
     ````
    
*/
enum ImpedenceSetting {
    /// Set the instrument's impedence to a standard 50Ω.  This is often used if you are driving a standard circuit.
    case standard

    /// Infinite Impedence is used when connecting directly to other high impedence instruments.  If this setting isn't used, then the high impedence instruments will see 2⨉ the desired volutage
    case infinite

    /// Set impedence to an arbitrary postive value
    case finite(UInt)
    
    /// Returns a VISA command string that can be used to set the Impedence of the instrument
    /// - Returns String: The VISA command to set the Impedence
    func command() -> String {
        switch self {
        case .standard:
            return "LOAD \(50)"
        case .infinite:
            return "LOAD INF"
        case let .finite(value):
            return "LOAD \(value)"
        }
    }
}

enum WaveformType {
    case DC
    
    func command() -> String {
        switch self {
        case .DC:
            return "FUNCtion DC"
        }
    }
}
