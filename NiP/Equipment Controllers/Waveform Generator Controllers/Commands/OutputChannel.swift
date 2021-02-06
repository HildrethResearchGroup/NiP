//
//  OutputChannel.swift
//  NiP
//
//  Created by Owen Hildreth on 2/5/21.
//

enum OutputChannel: UInt, VISACommand {
    case one = 1
    case two = 2
    
    
    /**
     Returns a VISA command string that can be used to set the output/source channel
     
     This command __CAN__ be used directly.
     
     - Returns
        - A string containing the VISA commandto set the output/source channel
     
     ### Usage Example: ###
         let outputChannel = OutputChannel.one
         let command = outputChannel.command()
         // returns: SOURce1
     */
    func command() -> String {
        return "SOURce\(self.rawValue)"
    }
}
