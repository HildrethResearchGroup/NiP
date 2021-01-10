//
//  StageParameters.swift
//  NiP
//
//  Created by Owen Hildreth on 12/23/20.
//

struct VelocityAndAcceleration {
    var vel: Double?
    var acc: Double?
}

enum StageQueueType {
    case movement
    case monitoring
}

enum StageState: String, CaseIterable, Identifiable {
    case notConnected
    case idle
    case moving
    
    var id: String { self.rawValue }
}
