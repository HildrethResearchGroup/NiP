//
//  CommandBuilder.swift
//  NiP
//
//  Created by Owen Hildreth on 2/5/21.
//

class CommandBuilder {
    static func command(_ commands: [VISACommand]) -> String {
        var commandString = ""
        let count = commands.count
        
        for (index, nextCommand) in commands.enumerated() {
            let nextCommandString = nextCommand.command()
            if index == count - 1 {
                commandString.append(nextCommandString)
            } else {
                commandString.append(nextCommandString + ":")
            }
        }
        
        return commandString
    }
}
