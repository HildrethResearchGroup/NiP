//
//  Extension_StringfromDouble.swift
//  NiP
//
//  Created by Dr. Owen Hildreth (Admin) on 1/8/21.
//

import Foundation

extension String {
    
    /** Creates a string from a Double using the supplied number formater.
     
     Note: The default string is: "??.???" if the formatter fails to generate a string
     
     - Parameters:
        - double: The number to generate a string from
        - formatter: The NumberFormater that informs how to format the string
     */
    init(double: Double, withFormatter formatter: NumberFormatter) {
        let errorValue = formatter.notANumberSymbol ?? "??.???"
        if let valueAsString = formatter.string(from: NSNumber(value: double)) {
            self = valueAsString
        } else { self = errorValue}
    }
}
