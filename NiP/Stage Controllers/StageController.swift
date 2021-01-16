//
//  StageController.swift
//  NiP
//
//  Created by Owen Hildreth on 1/6/21.
//

import Foundation
import Combine
import SwiftUI
import XPSQ8Kit

class StageController: ObservableObject {
    // MARK: Main XPS8 Objects
    let controller: XPSQ8Controller?
    let stageName:String
    let stage: Stage?
    let stageGroupController: StageGroupController?
    var stageGroup: StageGroup? {
        get { return stageGroupController?.stageGroup }
    }
    
    // MARK: State Variables
    var subscribers = Set<AnyCancellable>()
    
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
    @Published public var currentStageSGammaParameters: StageSGammaParameters = .largeDisplacement {
        didSet {
            print("currentStageSGammaParameters = \(currentStageSGammaParameters)")
            if currentStageSGammaParameters != oldValue {
                self.setSGammaParameters(currentStageSGammaParameters)
            }
        }
    }
    @Published public var isStageMoving = false
 

    // MARK: Init
    init(stageGroupController: StageGroupController?, andName stageNameIn: String, inController: XPSQ8Controller?) {
        controller = inController
        stageName = stageNameIn
        
        if let tempStageGroup = stageGroupController?.stageGroup {
            stage = Stage(stageGroup: tempStageGroup, stageName: stageNameIn)
        } else {stage = nil}
        self.stageGroupController = stageGroupController
        
        self.setSGammaParameters(currentStageSGammaParameters)
        
        monitorCurrentPosition = true
        updateCurrentPositionContinuously()
    }
}


// MARK: - Helper Functions
extension StageController {
    func defaultNumberToStringFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesSignificantDigits = true
        formatter.minimumSignificantDigits = 5
        formatter.maximumSignificantDigits = 5
        formatter.notANumberSymbol = "??.?????"
        
        return formatter
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
        controller?.dispatchQueue.async {
            //stage.moveRelative(targetDisplacement: targetDisplacement)
            do {
                try self.stage?.moveRelative(targetDisplacement: targetDisplacement)
            } catch {
                print(error)
            }
        }
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
        controller?.dispatchQueue.async {
            //stage.moveRelative(targetDisplacement: targetDisplacement)
            do {
                try self.stage?.moveAbsolute(toLocation: toLocation)
            } catch {
                print(error)
            }
        }
    } // END: moveAbsolute
    
    
    
    func setSGammaParameters(_ parameters: StageSGammaParameters) {
        self.setSGammaParameters(parameters.sGammaParameters)
    }
    
    
    func setSGammaParameters(_ parameters: SGammaParameters) {
        controller?.dispatchQueue.async {
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
    enum ControllerError: Error {
        case communicationError
    }
    
    func getCurrentPosition() -> Future<Double, Error> {
        let future = Future<Double, Error> { promise in
            self.controller?.dispatchQueue.async {
                do {
                    if let currentPosition = try self.stage?.getCurrentPosition() {
                        promise(Result.success(currentPosition))
                    } else {
                        promise(Result.failure(ControllerError.communicationError))
                    }
                } catch {
                    promise(Result.failure(error))
                }
            }
        }
        return future
    }
    
    
    func updateCurrentPositionContinuously() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [self]timer  in
            let future = self.getCurrentPosition()
            future.replaceError(with: -123.456)
            //future.replaceError(with: 0.0)
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


