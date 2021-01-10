//
//  StageController.swift
//  NiP
//
//  Created by Owen Hildreth on 12/22/20.
//

import Foundation
import Combine
import XPSQ8Kit


class StageGroupController: ObservableObject, ConnectableEquipment {
    var equipmentName = "XPSQ8"
    private var dispatchQueue: DispatchQueue
    private let identifier = "StageController"
    
    var controller: XPSQ8Controller? {
        didSet {
            if controller != nil {
                // XPSQ8Controller is no longer nil.  It is not possible to create the stages
                createStages()
                
                // Update connectedToController state
                connectedToController = true
                
                // Send notification out that the controller is no longer nil and the stages should be ready to communicateto and control.
                let nc = NotificationCenter.default
                nc.post(name: Notification.Name(SCNotification_controllerConnected), object: self)
            }
        }
    }
    
    @Published var connectedToController = false
    
    var stageGroup: StageGroup?
    lazy var x:StageController = StageController(stageGroupController: nil, andName: "X", inController: nil)
    lazy var y = StageController(stageGroupController: nil, andName: "Y", inController: nil)
    lazy var z = StageController(stageGroupController: nil, andName: "Z", inController: nil)
    var stageControllers: [StageController] = []
    
    
    init() {
        dispatchQueue = DispatchQueue(label: identifier, qos: .userInitiated)
        
    } // END: init()
    
    
    
    public func connectToEquipmentController() {
        controller = XPSQ8Controller(address: "192.168.0.254", port: 5001, identifier: "XPS8Q")
    }
    
    
    /** Stages can only be created once the controller: XPSQ8Controller is not nil.
     This function creates the StageGroup and XYZ StageControllers and then puts the XYZ Stage Controllers into the stageControllers array once the XPSQ8Controller is not nil
    */
    private func createStages() {
        stageGroup = StageGroup(controller: controller, stageGroupName: "M")
        self.x =  StageController(stageGroupController: self, andName: "X", inController: controller)
        self.y =  StageController(stageGroupController: self, andName: "Y", inController: controller)
        self.z =  StageController(stageGroupController: self, andName: "Z", inController: controller)
    }
}


// MARK: - Moving Stages
extension StageGroupController {
    
    
    
    
    
    
    
    
} // END:  Moving Stages Extension



// MARK: - Getting Data
extension StageGroupController {
    
    
    /**
     Returns a VelocityAndAcceleration Struct containing the current velocity and acceration of the specified stage.
     
      Implements  the ````void GatheringCurrentNumberGet(int* CurrentNumber, int* MaximumSamplesNumber))```` XPS function at the Stage Group through the Controller getCurrent function.
     
     - Parameters:
        - stage: The stage that will supply the data
     
     - returns:
        - A Future with a VelocityAndAcceleration values

     
     # Example #
     ````
     // NEED to provide an example
     ````
     
    - Author:  Owen Hildreth
    */
    func jogGetCurrent(_ stage: Stage) -> Future <VelocityAndAcceleration, Error> {
        
        return Future() { promise in
            self.controller?.dispatchQueue.async {
                do {
                    let jogGetResults = try stage.jogGetCurrent()
                    let velocity = jogGetResults?.velocity
                    let acceleration = jogGetResults?.acceleration

                    let velAndAcc = VelocityAndAcceleration(vel: velocity, acc: acceleration)
                    
                    promise(Result.success(velAndAcc))
                    
                } catch {
                    promise(Result.failure(error))
                }
            }
            
           
        }
    }// END:  jogGetCurrent
    
    
    
    
    
} // END:  Getting Data Extension
    
    
