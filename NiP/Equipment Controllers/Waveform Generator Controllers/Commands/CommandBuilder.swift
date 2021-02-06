//
//  CommandBuilder.swift
//  NiP
//
//  Created by Owen Hildreth on 2/5/21.
//


/**
    This is class is used to build a VISACommand string from an array of objects conforming to the VISACommand protocol.
 
     ### Usage Example: ###
             let outputChannel = OutputChannel.one
             let waveform = WaveformType.DC
          
             let command = CommandBuilder.command([outputChannel, waveform])
             // returns: SOURce1:FUNCtion DC
 */
class CommandBuilder {
    
    /**
     Takes an array of objects conforming to the VISACommand protocol and composes a command string combining all of the command strings from the objects.
     
     This command __CAN__ be used directly.  The commands will be ordered in the same order that the VISACommand array is.
     
     - Returns
        - A string containing the VISA command to set the type of waveform to generate
     
     - Parameters:
        - commands: An array of objects conforming to the VISACommand protocol.
     
    ### Usage Example: ###
            let outputChannel = OutputChannel.one
            let waveform = WaveformType.DC
         
            let command = CommandBuilder.command([outputChannel, waveform])
            // returns: SOURce1:FUNCtion DC
    */
    static func command(_ commands: [VISACommand]) -> String {
        var commandString = ""
        let count = commands.count
        
        for (index, nextCommand) in commands.enumerated() {
            let nextCommandString = nextCommand.command()
            if index == count - 1 {  // Don't add a ":" for the last command
                commandString.append(nextCommandString)
            } else {
                commandString.append(nextCommandString + ":")
            }
        }
        
        return commandString
    }
}
