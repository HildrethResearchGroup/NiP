//
//  Time.swift
//  NiP
//
//  Created by Owen Hildreth on 2/7/21.
//

struct Time {
    var value: Double = 0.0
    var units = TimeUnit.sec
    var baseUnits = TimeUnit.sec
    
    
    func valueInBaseUnits() -> Double {
        return TimeUnit.convert(self.value, from: self.units, to: self.baseUnits)
    }
}
