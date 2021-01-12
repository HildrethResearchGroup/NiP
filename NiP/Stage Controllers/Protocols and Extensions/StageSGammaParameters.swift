//
//  StageSGammaParameters.swift
//  NiP
//
//  Created by Dr. Owen Hildreth (Admin) on 1/8/21.
//




enum StageSGammaParameters: String, CaseIterable, Identifiable, Hashable {
    case largeDisplacement
    case mediumDisplacement
    case smallDisplacement
    case fineDisplacement
    
    var sGammaParameters: SGammaParameters {
        get {
            switch self {
            case .largeDisplacement:
                return SGammaParameters(velocity: 10, acceleration: 100, minimumTjerkTime: 0.02, maximumTjerkTime: 0.02)
            case .mediumDisplacement:
                return SGammaParameters(velocity: 1, acceleration: 10, minimumTjerkTime: 0.02, maximumTjerkTime: 0.02)
            case .smallDisplacement:
                return SGammaParameters(velocity: 0.1, acceleration: 5, minimumTjerkTime: 0.02, maximumTjerkTime: 0.02)
            case .fineDisplacement:
                return SGammaParameters(velocity: 0.01, acceleration: 1, minimumTjerkTime: 0.02, maximumTjerkTime: 0.02)
            }
        }
    }
    
    var id: String { self.rawValue }
}

struct SGammaParameters {
    var velocity: Double
    var acceleration: Double
    var minimumTjerkTime: Double
    var maximumTjerkTime: Double
}
