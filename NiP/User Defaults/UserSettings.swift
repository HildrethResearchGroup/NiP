//
//  UserSettings.swift
//  NiP
//
//  Created by Owen Hildreth on 1/29/21.
//

import Foundation
import Combine

class UserSettings: ObservableObject {
    @Published var waveformIdentifier: String {
        didSet {
            UserDefaults.standard.set(waveformIdentifier, forKey: "waveformIdentifier")
        }
    }
    
    
    @Published var XPSQ8Address: String {
        didSet {
            UserDefaults.standard.set(XPSQ8Address, forKey: "XPSQ8Address")
        }
    }
    
    @Published var XPSQ8Port: Int {
        didSet {
            UserDefaults.standard.set(XPSQ8Port, forKey: "XPSQ8Port")
        }
    }
    
    
    init() {
        
        // Create waveformIdentifier
        if let wfIdentifier = UserDefaults.standard.object(forKey: "waveformIdentifier") as? String {
            self.waveformIdentifier = wfIdentifier
        } else {
            self.waveformIdentifier = "USB0::0x0957::0x2607::MY52200879::INSTR"
        }
        
        
        // Create XPSX8 IP address
        if let xpsAddress = UserDefaults.standard.object(forKey: "XPSQ8Address") as? String {
            self.XPSQ8Address = xpsAddress
        } else {
            self.XPSQ8Address = "192.168.0.254"
        }
        
        
        // Create XPSX8 Port
        if let xpsPort = UserDefaults.standard.object(forKey: "XPSQ8Port") as? Int {
            self.XPSQ8Port = xpsPort
        } else {
            self.XPSQ8Port = 5001
        }
        
        
    }
    

}
