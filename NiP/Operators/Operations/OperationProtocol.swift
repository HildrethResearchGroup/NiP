//
//  OperationProtocol.swift
//  NiP
//
//  Created by Owen Hildreth on 2/7/21.
//

protocol Operation {
    var state: OperationState {get set}
    var enabled: Bool {get set}
    var operationType: OperationType { get }
}
