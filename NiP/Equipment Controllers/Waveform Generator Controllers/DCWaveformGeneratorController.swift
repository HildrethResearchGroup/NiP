//
//  DCWaveformGeneratorController.swift
//  NiP
//
//  Created by Owen Hildreth on 1/18/21.
//

import Foundation
import Combine
import SwiftVISA
//import SwiftVISASwift

// TODOP:  Update didSets ton published values.  Create subscribers.

class DCWaveformGeneratorController: EquipmentController, WaveformController {

    
    // MARK: - Properties
    var identifier: String // = "USB0::0x0957::0x2607::MY52200879::INSTR"
    static var minimumDelay: UInt32 = 2_000_000
    @Published var voltage = 0.0 {
        didSet {
            do {
                try updateVoltage(voltage)
            } catch {
                print("Error when trying to set voltage")
                print(error) } }
    }
    private let startupVoltage = 0.0
    private let turnedOffVoltage = 0.0
    private var instrument: MessageBasedInstrument?
    @Published var outputChannel: UInt
    @Published var waveformType: WaveformType = .DC {
        didSet {
            do {
                try updateWaveform(waveformType)
            } catch {
                print("Error when trying to set Waveform")
                print(error) }
        }
    }
    
    
    @Published var impedence: ImpedenceSetting = .infinite {
        didSet {
            do {
                try updateImpedence(impedence)
            } catch {
                print("Error when trying to set Impedence")
                print(error) }
        }
    }
    
    
    // MARK: - Dispatch queue
    
    var dispatchQueue: DispatchQueue? {
        return DispatchQueue.global(qos: .userInitiated)
    }
    
    
    
    
    // MARK: - Initializers
    required init(identifier: String, outputChannel: UInt = 1) {
        print("Initilize instrument")
        self.identifier = identifier
        
        self.outputChannel = outputChannel
        self.waveformType = .DC
        super.init(equipmentName: "DC Waveform")
    }
    
    
    override func connectToEquipmentController() {
        
        //TODO: Switch over to SwiftVISASwift
        //guard let newInstrument = try? InstrumentManager.shared.instrumentAt(address: "169.254.5.21", port: 5001) else {
        
        guard let newInstrument = try? InstrumentManager.default?.makeInstrument(identifier: "USB0::0x0957::0x2607::MY52200879::INSTR") as? MessageBasedInstrument else {
            print("Could not make waveform generator")
            print("identifier = \(identifier)")
                return }
        
        connectedToController = true
        equipmentState = .idle
        
        self.instrument = newInstrument
        
        do {
            try updateImpedence(self.impedence)
        } catch { print(error) }
        
        do {
            try updateVoltage(self.voltage)
        } catch { print(error) }
        do {
            try updateWaveform(self.waveformType)
        } catch { print(error) }
    }
}


// MARK: - WaveformController Protocol
extension DCWaveformGeneratorController {
    /**func getIdentifier() throws -> String? {
        return try (instrument?.query("*IDN?\n", as: String.self, decoder: StringDecoder()))
    }
    */
    
    /**
    Set the Impedence of the instrument
    
    - Parameter impedenceSetting: enum of the target impedence
    */
    func updateImpedence(_ impedenceSetting: ImpedenceSetting) throws {
        let outputString = "OUTPUT\(outputChannel)"
        let impedenceString = impedenceSetting.command()
        let commandString = outputString + ":" + impedenceString
        try instrument?.write(commandString)  // Example: OUTPUT1:LOAD INF""
    }
    
    
    /**
    Set the Output Voltage of the instrument
    
    - Parameter voltage: The target output voltage
    */
    func updateVoltage(_ voltage: Double) throws {
        try instrument?.write("SOURce\(outputChannel):VOLTage:OFFSet \(voltage)")
    }
    
    func updateWaveform(_ waveform: WaveformType) throws {
        let waveformCommand = waveformType.command()
        try instrument?.write("SOURce\(outputChannel):\(waveformCommand)")
    }
    
}

// MARK: - Running the Waveform
extension DCWaveformGeneratorController  {
    func runWaveform(for runTime: Double) throws {
        
        // Rerun setVoltage to make sure the system is definitely on an ready to run the waveform
        try updateVoltage(voltage)
        
        // Turn the channel on.
        try turnChannelOn()
        
        // Make sure that the input runTime isn't negative
        if runTime < 0 {return}
        
        // Calculate the run time
        let runLength = DispatchTime.now() + Double(runTime)
        
        
        // Have stopWaveform run after runLength
        
        DispatchQueue.main.asyncAfter(deadline: runLength, execute: {
            self.stopWaveform()
            } as @convention(block) () -> Void)

        
    }
    
    // TODO: Need to make stopWaveform a throwing function.  However, I need to figure out how to do asyn throwing functions
    func stopWaveform() {
        do {
            try instrument?.write("OUTPUT\(outputChannel) OFF")
        } catch {
            print(error)
            self.equipmentState = .notConnected
        }
        self.equipmentState = .idle
    }
    
    func turnChannelOn() throws {
        try instrument?.write("OUTPUT\(outputChannel) ON")
        self.equipmentState = .busy
    }
}


// MARK: - Decoders
extension DCWaveformGeneratorController {
    // TODO - Fix VISADecoder
    /**
    private struct StringDecoder: VISADecoder {
        func decode(_ string: String) throws -> String {
            var fixedString = string
            
            if string.hasPrefix("1`") {
                fixedString = String(string.dropFirst(2))
            }
            
            while fixedString.hasSuffix("\n") {
                fixedString = String(fixedString.dropLast())
            }
            
            return fixedString
        }
    }
 */
}

