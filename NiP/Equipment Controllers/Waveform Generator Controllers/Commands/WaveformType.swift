//
//  WaveformType.swift
//  NiP
//
//  Created by Owen Hildreth on 2/5/21.
//

enum WaveformType: String, VISACommand {
    case DC = "DC"
    
    
    /**
     Returns a VISA command string that can be used to set the type of waveform to generate
     
     This command __CANNOT__ be used direclty and must be paired with the Source command to specify which channel this command should be applied to.
     Alternatively, you can use the ````func command(_ outputChannel: UInt) -> String```` to get the entire command string
     
     - Returns
        - A string containing the VISA command to set the type of waveform to generate
     
     
     ### Usage Example: ###
         let waveform = WaveformType.DC
         let command = waveform.command()
         // returns: FUNCtion DC
    */
    func command() -> String {
        return "FUNCtion \(self.rawValue)"
    }
    
    
    /**
     Returns a VISA command string that can be used to set the type of waveform to generate
     
     This command __CAN__ be used directly.
     
     - Returns
        - A string containing the VISA command to set the type of waveform to generate
     
     - Parameters:
        - outputChannel: The channel that this command should be applied to.
     
     ### Usage Example: ###
         let waveform = WaveformType.DC
         let outputChannel = OutputChannel.one
         let command = waveform.command(outputChannel)
         // returns: OUTPUT1:FUNCtion DC
    */
    func command(_ outputChannel: OutputChannel) -> String {
        return CommandBuilder.command([outputChannel, self])
    }
    
    
}
