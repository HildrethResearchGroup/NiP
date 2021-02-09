//
//  VoltageOffsetCommand.swift
//  NiP
//
//  Created by Owen Hildreth on 2/8/21.
//

struct VoltageOffsetCommand: VISACommand {
    var voltage: Double
    
    init(_ voltageIn: Double) {
        voltage = voltageIn
    }
    
    func command() -> String {
        return "VOLTage:OFFSet \(voltage)"
    }
}
