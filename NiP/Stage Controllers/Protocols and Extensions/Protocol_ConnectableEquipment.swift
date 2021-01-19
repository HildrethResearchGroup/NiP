//
//  Protocol_ConnectableEquipment.swift
//  NiP
//
//  Created by Owen Hildreth on 1/7/21.
//
import Combine
import SwiftUI

protocol ConnectableEquipment: ObservableObject {
    func connectToEquipmentController()
    var equipmentState: EquipmentState {get set}
    var equipmentName: String {get set}
}


enum connectionState {
    case connected
    case notConnected
    case error
}

enum EquipmentState {
    case notConnected
    case idle
    case busy
}
