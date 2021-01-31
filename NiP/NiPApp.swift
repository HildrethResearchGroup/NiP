//
//  NiPApp.swift
//  NiP
//
//  Created by Owen Hildreth on 12/22/20.
//

import SwiftUI

@main
struct NiPApp: App {
    let userSettings = UserSettings()
    
    var body: some Scene {
        WindowGroup {
            ContentView(userSettings: userSettings)
                .environmentObject(userSettings)
        }
        
        #if os(macOS)
        Settings {
            PreferencesPanel()
                .environmentObject(userSettings)
        }
        #endif
    }
}


