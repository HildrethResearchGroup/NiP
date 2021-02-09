//
//  StepFunction.swift
//  NiP
//
//  Created by Owen Hildreth on 2/5/21.
//

struct StepFunction: VISACommand {
    var voltage = 0.0
    var time = Time(value: 0.0, units: .sec)
    
    let waveform = WaveformType.DC
    
    /**
     Returns a VISA command string that can be used to set the Voltage of the instrument.
     
     This command __CANNOT__ be used direclty and must be paired with the Source command to specify which channel this command should be applied to.
     Alternatively, you can use the ````func command(_ outputChannel: OutputChannel) -> String```` to get the entire command string
     
     - Returns
        - A string containing the VISA command to set the voltage
     
     
        ### Usage Example: ###
            var stepFunction = StepFunction()
            stepFunction.voltage = 1.23
            let command = stepFunction.command()
            // returns: VOLTage:OFFSet 1.23
     */
    func command() -> String {
        return "VOLTage:OFFSet \(voltage)"
    }
    
    
    
    /**
     Returns a VISA command string that can be used to set the Voltage of the instrument.
     
     This command __CAN__ be used directly.
     
     - Returns
        - A string containing the VISA command to set the voltage
     
     - Parameters
        - outputChannel The channel to send the command to.
     
     
        ### Usage Example: ###
            var stepFunction = StepFunction()
            stepFunction.voltage = 1.23
            let outputChannel = OutputChannel.one
            let command = stepFunction.command(outputChannel)
            // returns: OUTPUT1:VOLTage:OFFSet 1.23
     */
    func command(_ outputChannel: OutputChannel) -> String {
        return CommandBuilder.command([outputChannel, self])
    }
    
    
}
