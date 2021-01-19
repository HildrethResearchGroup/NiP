//
//  EquipmentController.swift
//  NiP
//
//  Created by Owen Hildreth on 1/18/21.
//

import Combine


class EquipmentController: ObservableObject {
    var equipmentName: String
    @Published var equipmentState: EquipmentState = .notConnected
    @Published var connectedToController = false
    var subscriptions: Set<AnyCancellable> = []
    
    
    init(equipmentName equipmentNameIn: String) {
        equipmentName = equipmentNameIn
    }
    
    func connectToEquipmentController() {
        
    }
}
