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
    let stage: Stage
    let stageGroupController: StageGroupController
    var stageGroup: StageGroup? {
        get { return stageGroupController.stageGroup }
    }
    
    let defaultStageSGammaParameters: StageSGammaParameters = .largeDisplacement

    
    init?(stageGroupController: StageGroupController, andName stageNameIn: String, inController: XPSQ8Controller?) {
        controller = inController
        stageName = stageNameIn
        
        guard let tempStageGroup = stageGroupController.stageGroup else {return nil}
        stage = Stage(stageGroup: tempStageGroup, stageName: stageNameIn)
        
        self.stageGroupController = stageGroupController
        
        self.setSGammaParameters(defaultStageSGammaParameters)
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
                try self.stage.moveRelative(targetDisplacement: targetDisplacement)
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
    func moveAbsolute(toLocation: Double) throws {
        controller?.dispatchQueue.async {
            //stage.moveRelative(targetDisplacement: targetDisplacement)
            do {
                try self.stage.moveAbsolute(toLocation: toLocation)
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
                try self.stage.setSGammaParameters(velocity: vel, acceleration: acc, minimumTjerkTime: min, maximumTjerkTime: max)
            } catch {
                print(error)
            }
        }
    }
}


