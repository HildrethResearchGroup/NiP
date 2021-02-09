//
//  ChannelOnCommand.swift
//  NiP
//
//  Created by Owen Hildreth on 2/7/21.
//

enum ChannelOnOff: String {
    case on = "ON"
    case off = "OFF"
}

struct ChannelOnOffCommand: VISACommand {
    var outputChannel: OutputChannel
    var channelOnOff: ChannelOnOff
    
    func command() -> String {
        return "OUTPUT\(self.outputChannel.rawValue) \(self.channelOnOff.rawValue)"
    }
}
