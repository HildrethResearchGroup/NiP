//
//  Protocol_ConnectableEquipment.swift
//  NiP
//
//  Created by Owen Hildreth on 1/7/21.
//

protocol ConnectableEquipment {
    func connectToEquipmentController()
}


enum connectionState {
    case connected
    case notConnected
    case error
}
