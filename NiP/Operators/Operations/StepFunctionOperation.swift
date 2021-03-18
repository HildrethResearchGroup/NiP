//
//  StepFunctionOperation.swift
//  NiP
//
//  Created by Owen Hildreth on 2/7/21.
//
import Combine
import SwiftUI

class StepFunctionOperation: ObservableObject {
    let operationType: OperationType = .stepFunction
    @Published var state = OperationState.unused
    @Published var targetVoltage = 0.0
    @Published var duration = Time()
    @Published var elapsedTime: Double? = nil
    @Published var outputChannel: OutputChannel = .one
    
    let waveformType = WaveformType.DC
    
}

