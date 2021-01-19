//
//  Protocol_ConnectableEquipment.swift
//  NiP
//
//  Created by Owen Hildreth on 1/7/21.
//
import Combine
import SwiftUI


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
