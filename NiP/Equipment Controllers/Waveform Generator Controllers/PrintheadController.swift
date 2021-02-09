//
//   PrintheadController.swift
//  NiP
//
//  Created by Owen Hildreth on 2/5/21.
//

import Foundation
import SwiftVISA

class PrintheadController: EquipmentController {
    var dcWaveformGeneratorController: DCWaveformGeneratorController? = nil {
        didSet {
            if dcWaveformGeneratorController != nil {
                self.equipmentState = .idle
            }
        }
    }
    
    // MARK: - State Variables
    @Published var targetVoltage = 0.0
    @Published var amplificationFactor = 1000.0
    @Published var voltage = 0.0 { didSet {  dcWaveformGeneratorController?.voltage = voltage } }
    @Published var runTime: Double = 0.0
    @Published var elapsedTime: Double = 0.0
    
    var currentOperation: Operation? = nil
    
    
    // MARK: - Connection Functions
    override func connectToEquipmentController() {
        let waveformIdentifier = UserSettings().waveformIdentifier
        
        dcWaveformGeneratorController = DCWaveformGeneratorController(identifier: waveformIdentifier, outputChannel: .one)
        dcWaveformGeneratorController?.voltage = voltage
        
    }
    
    
    func write(_ command: VISACommand) throws {
        let commandString = command.command()
        try self.write(commandString)
    }
    
    func write(_ commands: [VISACommand]) throws {
        let commandString = CommandBuilder.command(commands)
        
        try self.write(commandString)
    }
    
    func write(_ commandString: String) throws {
        try self.dcWaveformGeneratorController?.write(commandString)
    }
    
    
}


// MARK: - Running Operations
extension PrintheadController {
    func runOperation(_ operation: Operation) {
        switch operation.operationType {
        case .stepFunction:
            if let stepFunctionOperation = operation as? StepFunctionOperation {
                self.runStepFunction(stepFunctionOperation)
            }
        }
    } // END: runOperation
    
} // END: Running Operations Extension




// MARK: - Building Block Operations
extension PrintheadController {
    func updateOffsetVoltage(onChannel channel: OutputChannel, toVoltage voltageCommand: VoltageOffsetCommand) throws {
        let commands: [VISACommand] = [channel, voltageCommand]
        
        try self.write(commands)
    }
    
    
    func turnChannelOn(_ channel: OutputChannel) throws {
        let command = ChannelOnOffCommand(outputChannel: channel, channelOnOff: .on)
        try self.write(command)
        self.equipmentState = .busy
    }
    
    
    func turnChannelOff(_ channel: OutputChannel) throws {
        let command = ChannelOnOffCommand(outputChannel: channel, channelOnOff: .off)
        
        try self.write(command)
        self.equipmentState = .idle
    }
    
    
    
    func stopWaveform(_ channel: OutputChannel) {
        do {
            try turnChannelOff(channel)
        } catch {
            print(error)
            return
        }
        self.equipmentState = .idle
    }
}// END: Building Block Operations Extension




// MARK: - Run Step Function Operation
extension PrintheadController {
    
    func runStepFunction(_ operation: StepFunctionOperation) {
        targetVoltage = operation.targetVoltage
        voltage = targetVoltage / amplificationFactor
        
        runTime = operation.duration.valueInBaseUnits()
        
        // Gather commands
        let voltageCommand = VoltageOffsetCommand(voltage)
        
        // Make sure that the input runTime isn't negative
        if runTime < 0 {return}
        
        // Try to update offset voltage
        do {
            try updateOffsetVoltage(onChannel: operation.outputChannel, toVoltage: voltageCommand)
        } catch {
            print(error)
            return
        }
        
        // Turn the channel on.
        do {
            try turnChannelOn(operation.outputChannel)
        } catch {
            print(error)
            return
        }
        
        
        // Calculate the run time
        let runLength = DispatchTime.now() + Double(runTime)
        
        // Have stopWaveform run after runLength
        DispatchQueue.main.asyncAfter(deadline: runLength, execute: { [weak self] in
            self?.stopWaveform(operation.outputChannel)
            } as @convention(block) () -> Void)
        
    } // END:  runStepFunction
    
} // END:  Run Step Function Operation Extension
