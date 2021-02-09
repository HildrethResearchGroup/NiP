//
//  TimeScale.swift
//  NiP
//
//  Created by Owen Hildreth on 2/5/21.
//

enum TimeUnit: Double {
    case nsec = 1.0e-9
    case µsec = 1.0e-6
    case msec = 1.0e-3
    case sec = 1.0
    case min = 60.0
    case hr = 3600.0
    case day = 86.4e3
    
    static func convert(_ value: Double, from fromUnit: TimeUnit, to toUnit: TimeUnit) -> Double {
        let ratio = fromUnit.rawValue / toUnit.rawValue
        
        return value * ratio
    }
}


