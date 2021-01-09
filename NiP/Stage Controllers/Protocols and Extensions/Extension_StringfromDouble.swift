//
//  Extension_StringfromDouble.swift
//  NiP
//
//  Created by Dr. Owen Hildreth (Admin) on 1/8/21.
//

import Foundation

extension String {
    init(double: Double, withFormatter formatter: NumberFormatter) {
        let errorValue = formatter.notANumberSymbol ?? "??.???"
        if let valueAsString = formatter.string(from: NSNumber(value: double)) {
            self = valueAsString
        } else { self = errorValue}
        
        
    }
}
