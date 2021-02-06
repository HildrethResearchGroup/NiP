//
//  StepFunction.swift
//  NiP
//
//  Created by Owen Hildreth on 2/5/21.
//

struct StepFunction: VISACommand {
    var voltage = 0.0
    var duration = Duration(duration: 0.0, timeScale: .sec)
    
    let waveform = WaveformType.DC
    
    /**
     Returns a VISA command string that can be used to set the Voltage of the instrument.
     
     This command __CANNOT__ be used direclty and must be paired with the Source command to specify which channel this command should be applied to.
     Alternatively, you can use the ````func command(_ outputChannel: UInt) -> String```` to get the entire command string
     
     - Returns
        - A string containing the VISA command to set the voltage
     
     
     ### Usage Example: ###
         var stepFunction = StepFunction()
         stepFunction.voltage = 1.23
         let outputChannel = UInt(1)
            let waveformCommand = stepFunction.waveform.
         let command = stepFunction.command(outputChannel)
         // returns: OUTPUT1:LOAD INF
    */
    func command() -> String {
        return "VOLTage:OFFSet \(voltage)"
    }
    
    func command(_ outputChannel: UInt) -> String {
        return "SOURce\(outputChannel):VOLTage:OFFSet \(voltage)"
    }
    
    
}
