//
//  StageController.swift
//  NiP
//
//  Created by Owen Hildreth on 1/6/21.
//

import Foundation
import Combine
import XPSQ8Kit

class StageController: ObservableObject {
    let controller: XPSQ8Controller?
    let stageName:String
    let stage: Stage?
    let stageGroupController: StageGroupController?
    var stageGroup: StageGroup? {
        get { return stageGroupController?.stageGroup }
    }
    
    var subscribers = Set<AnyCancellable>()

    // MARK: State
    var stageIsMoving = false {
        didSet {
            print("stageisMoving = \(stageIsMoving)")
            updateState()
        }
    }
    @Published var state = StageState.notConnected
    
    var monitorCurrentPosition = false {
        didSet {
            if monitorCurrentPosition == true && oldValue == false {
                updateCurrentPositionContinuously()
            }
        }
    }
    var timeLengthToUpdatePosition = 0.25
    
    @Published var currentPosition = 0.0 {
        didSet {
            if oldValue != currentPosition {
                let formatter = self.defaultNumberToStringFormatter()
                currentPositionString = String(double: currentPosition, withFormatter: formatter)
            }
        }
    }
    @Published var currentPositionString:String = "??.???"
    
    
    // MARK: Settings
    @Published var stageSGammaParameters: StageSGammaParameters = .largeDisplacement
    
    
    init(stageGroupController: StageGroupController?, andName stageNameIn: String, inController: XPSQ8Controller?) {
        controller = inController
        stageName = stageNameIn

        if let tempStageGroup = stageGroupController?.stageGroup {
            stage = Stage(stageGroup: tempStageGroup, stageName: stageNameIn)
        } else {stage = nil}
        self.stageGroupController = stageGroupController
        
        self.setSGammaParameters(stageSGammaParameters)
        
        // Turn off monitoring
        monitorCurrentPosition = false
        updateCurrentPositionContinuously()
        updateState()
    }
}

// MARK: - Helper Functions
extension StageController {
    
    /** Provides a default number formatter use to format the position of the stages
    - Authors:
        Owen Hildreth
     */
    func defaultNumberToStringFormatter() -> NumberFormatter {
        // TODO: Find a better home for this function.
        let formatter = NumberFormatter()
        formatter.usesSignificantDigits = true
        formatter.minimumSignificantDigits = 5
        formatter.maximumSignificantDigits = 5
        formatter.notANumberSymbol = "??.?????"
        
        return formatter
    }
    
    /**
        Updates the state of the stages.  Used for monitoring the stages.
     */
    func updateState() {
        if controller == nil {
            self.state = .notConnected
            return
        }
        if stageIsMoving == true {
            self.state = .moving
            return
        }
        
        self.state = .idle
    }
    
    
    /**
     Provides a deafult queue to run a moment and montioring operations asynconously.
     
     It is important that each type of queue be differnet otherwise operations that take a long time (such as a movement) will block monitoring calls
     
     - Parameters:
        - type: The StageQueueType
     */
    func defaultQueue(for type: StageQueueType) -> DispatchQueue {
        
        let stageGroupName: String
        
        if stageGroup != nil {
            stageGroupName = stageGroup!.stageGroupName
        } else { stageGroupName = "A" }
        
        let queueType: String
        
        switch type {
        case .movement:
            queueType = "movement"
        case .monitoring:
            queueType = "monitoring"
        case .shared:
            queueType = "shared"
        }
        
        let identifier = stageGroupName + "_" + stageName + "_" + queueType
        
        return DispatchQueue(label: identifier, qos: .userInitiated)
    }
}

// MARK: - Moving Stages
extension StageController {
    /**
     Moves the stage using the moveRelative command by the target displacement in mm.
    - Parameters:
        - targetDisplacement: The distance in millimeters that the stage should be moved by using the moveRelative command
     
     # Example #
     ````
     // Setup Controller, StageGroup, and Stage
     let stageController = StageController()
     let stageToMove = stageController.x
    
     // Tell stage to move
     stageController.moveRelative(stageToMove, targetDisplacement: -5.0)
     ````
     - Author: Owen Hildreth
    */
    func moveRelative(targetDisplacement: Double) {
        
        self.stageGroupController?.moveRelative(stageController: self, targetDisplacement: targetDisplacement)
        
        /*
        // Don't send another move command if the stages are not idle
        if state != .idle {
            print("ERROR: moveRelative - Stages are not idle")
            return
        }
        
        // Get a unqiue dispatch queue for movement
        let dispatchQueue = self.defaultQueue(for: .movement)
        
        // Only move if the controller exists
        if controller != nil {
            // Run command asynchronously to keep from blocking
            dispatchQueue.sync {
                DispatchQueue.main.sync{self.stageIsMoving = true}
                do {
                    try self.stage?.moveRelative(targetDisplacement: targetDisplacement)
                } catch {
                    print(error)
                }
                DispatchQueue.main.sync{self.stageIsMoving = false}
            }
        }
         */
    } // END:  moveRelative
    
    
    /**
     Moves the stage using the moveAbsolution commadn to the target location.
     
     - Parameters:
        - stage: The stage that will be moved.
        - toLocation: The location in mm to move the stage to.
     
     # Example #
     ````
     // Setup Controller, StageGroup, and Stage
     let stageController = StageController()
     let stageToMove = stageController.x
        
     // Tell stage to move
     stageController.moveAbsolute(stageToMove, toLocation: 30.0)
     ````
     */
    func moveAbsolute(toLocation: Double) {
        // Don't send another move command if the stages are not idle
        if state != .idle {
            print("ERROR: moveRelative - Stages are not idle")
            return
        }
        
        // Get a unqiue dispatch queue for movement
        let dispatchQueue = self.defaultQueue(for: .movement)
        
        // Only move if the controller exists
        if controller != nil {
            // Run command asynchronously to keep from blocking
            dispatchQueue.sync {
                DispatchQueue.main.sync{self.stageIsMoving = true}
                do {
                    try self.stage?.moveAbsolute(toLocation: toLocation)
                } catch {
                    print(error)
                }
                DispatchQueue.main.sync{self.stageIsMoving = false}
            }
        }
    } // END: moveAbsolute
    
    
    func setSGammaParameters(_ parameters: StageSGammaParameters) {
        self.setSGammaParameters(parameters.sGammaParameters)
    }
    
    
    func setSGammaParameters(_ parameters: SGammaParameters) {
        // Get a unqiue dispatch queue for movement
        let dispatchQueue = self.defaultQueue(for: .monitoring)
        
        dispatchQueue.async {
            let vel = parameters.velocity
            let acc = parameters.acceleration
            let min = parameters.minimumTjerkTime
            let max = parameters.maximumTjerkTime

            do {
                try self.stage?.setSGammaParameters(velocity: vel, acceleration: acc, minimumTjerkTime: min, maximumTjerkTime: max)
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - Monitoring Stages
extension StageController {
    func getCurrentPosition() -> Future<Double, Error> {
        
        // Get a unqiue dispatch queue for movement
        let dispatchQueue = self.defaultQueue(for: .monitoring)
        
        let future = Future<Double, Error> { promise in
            dispatchQueue.async {
                do {
                    if let currentPosition = try self.stage?.getCurrentPosition() {
                        promise(Result.success(currentPosition))
                    } else {
                        promise(Result.failure(StageError.communicationError))
                    }
                } catch {
                    promise(Result.failure(error))
                }
            }
        }
        return future
    }
    
    
    func updateCurrentPositionContinuously() {
        if monitorCurrentPosition == false {return}
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [self]timer  in
            let future = self.getCurrentPosition()
            future.replaceError(with: -123.456)
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { value in
                    self.currentPosition = value
                })
                .store(in: &subscribers)
            
            if monitorCurrentPosition == false {
                timer.invalidate()
                //cancelable.cancel()
                print("done")
            }
        })
    }
}


