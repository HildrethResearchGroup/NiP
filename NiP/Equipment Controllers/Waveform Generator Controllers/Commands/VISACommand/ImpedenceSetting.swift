//
//  ImpedenceSetting.swift
//  NiP
//
//  Created by Owen Hildreth on 2/5/21.
//

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
enum ImpedenceSetting: VISACommand {
    /// Set the instrument's impedence to a standard 50Ω.  This is often used if you are driving a standard circuit.
    case standard

    /// Infinite Impedence is used when connecting directly to other high impedence instruments.  If this setting isn't used, then the high impedence instruments will see 2⨉ the desired volutage
    case infinite

    /// Set impedence to an arbitrary postive value
    case finite(UInt)
    
    
    
    /**
     Returns a VISA command string that can be used to set the Impedence of the instrument.
     
     This command __CANNOT__ be used direclty and must be paired with the Source command to specify which channel this command should be applied to.
     Alternatively, you can use the ````func command(_ outputChannel: UInt) -> String```` to get the entire command string
     
     - Returns
        - A string containing the VISA command to set the Impedence including the output channel section.
     
     
     ### Usage Example: ###
         let impedenceSetting = Impedence.infinite
         let outputChannel = UInt(1)
         let command = impedenceSetting.command(outputChannel)
         // returns: OUTPUT1:LOAD INF
    */
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
    
    
/**
     Returns a VISA command string that can be used to set the Impedence of the instrument.
     
     This command __CAN__ be used directly.
     
     - Returns
        - A string containing the VISA command to set the Impedence including the output channel section.
     
     - Parameters:
        - outputChannel: The channel that this command should be applied to.
     
     ### Usage Example: ###
     ````
     let impedenceSetting = Impedence.infinite
     let outputChannel = UInt(1)
     let command = impedenceSetting.command(outputChannel)
     // returns: OUTPUT1:LOAD INF
     ````
*/
    func command(_ outputChannel: OutputChannel) -> String {
        return CommandBuilder.command([outputChannel, self])
    }
}
