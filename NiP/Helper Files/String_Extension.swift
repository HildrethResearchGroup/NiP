//
//  String_Extension.swift
//  NiP
//
//  Created by Owen Hildreth on 1/13/21.
//
import Foundation

// MARK: - String - CamelCaps to Separate
extension String {
    var camelCaps: String {
        guard self.count > 0 else { return self }
        var newString: String = ""

        let uppercase = CharacterSet.uppercaseLetters
        let first = self.unicodeScalars.first!
        newString.append(Character(first))
        for scalar in self.unicodeScalars.dropFirst() {
            if uppercase.contains(scalar) {
                newString.append(" ")
            }
            let character = Character(scalar)
            newString.append(character)
        }

        return newString
    }
}


// MARK: - Number Formatter
extension String {
    init(double: Double, withFormatter formatter: NumberFormatter) {
        let errorValue = formatter.notANumberSymbol ?? "??.???,??"
        if let valueAsString = formatter.string(from: NSNumber(value: double)) {
            self = valueAsString
        } else { self = errorValue}
        
        
    }
}
