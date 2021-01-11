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
    
    var stageGroup: StageGroup?
    lazy var x:StageController = StageController(stageGroupController: nil, andName: "X", inController: nil)
    lazy var y = StageController(stageGroupController: nil, andName: "Y", inController: nil)
    lazy var z = StageController(stageGroupController: nil, andName: "Z", inController: nil)
    var stageControllers: [StageController] = []
    
    // MARK: State
    var subscribers = Set<AnyCancellable>()
    @Published var connectedToController = false {
        didSet {
            if connectedToController != oldValue {
                self.updateState()
            }
        }
    }
    @Published var state = StageState.notConnected {
        didSet {
            if oldValue == .moving  && state != oldValue {
                self.renewStagePositions()
            }
        }
    }
    var isMonitoring = false {
        didSet {
            if isMonitoring != oldValue {
                updateState()
            }
        }
    }
    var shouldMonitor = true
    
    
    // MARK: Setup
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
        
        stageControllers.append(x)
        stageControllers.append(y)
        stageControllers.append(z)
        
        renewStagePositions()
    }
    
    func updateState() {
        if controller == nil {
            self.state = .notConnected
            return
        }
        
        if self.isMonitoring == true {
            self.state = .monitoring
            return
        }
        
        for nextStageController in stageControllers {
            if nextStageController.stageIsMoving == true {
                self.state = .moving
                return
            }
        }
        
        self.state = .idle
    }
}


// MARK: - Moving Stages
extension StageGroupController {

    func moveRelative(stageController: StageController, targetDisplacement: Double) {
        // Don't send another move command if the stages are not idle
        if self.state != .idle {
            print("ERROR: moveRelative - Stages are not idle")
            return
        }
        
        if controller != nil {
            controller?.dispatchQueue.sync {
                DispatchQueue.main.sync { stageController.stageIsMoving = true }
                do {
                    try stageController.stage?.moveRelative(targetDisplacement: targetDisplacement)
                } catch {
                    print(error)
                }
                DispatchQueue.main.sync{stageController.stageIsMoving = false}
            }
        }
        
    }
    
    
    func moveAbsolute(stageController: StageController, toLocation: Double) {
        // Don't send another move command if the stages are not idle
        if state != .idle {
            print("ERROR: moveRelative - Stages are not idle")
            return
        }
        
        if controller != nil {
            controller?.dispatchQueue.sync {
                DispatchQueue.main.sync { stageController.stageIsMoving = true }
                do {
                    try stageController.stage?.moveAbsolute(toLocation: toLocation)
                } catch {
                    print(error)
                }
                DispatchQueue.main.sync{stageController.stageIsMoving = false}
            }
        }
        
    }
    
} // END:  Moving Stages Extension






// MARK: - Getting Data
extension StageGroupController {
    func renewStagePositions() {
        // Don't run monitoring if not necessary
        if shouldMonitor == false { return }
        
        // Run on a different thread
        controller?.dispatchQueue.async { [self] in
            DispatchQueue.main.sync{self.isMonitoring = true}
            
            for nextStageController in stageControllers {
                let stage = nextStageController.stage
                
                do {
                    guard let currentPosition = try stage?.getCurrentPosition()
                    else { print("renewStagePositions: ERROR trying to get data")
                        return}
                    DispatchQueue.main.sync{nextStageController.currentPosition = currentPosition}
                } catch  {
                    print("renewStagePositions: ERROR trying to get data")
                }
            }
            DispatchQueue.main.sync{self.isMonitoring = false}
        }
    }
    
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
    
    

