//
//  StageStatus.swift
//  NiP
//
//  Created by Owen Hildreth on 1/16/21.
//

enum StageMovingState: Int {
    case notMoving = 0
    case moving = 1
}

enum StageState {
    case notConnected
    case busy
    case idle
}
