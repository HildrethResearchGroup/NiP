//
//  ToolBars.swift
//  NiP
//
//  Created by Owen Hildreth on 1/17/21.
//

import SwiftUI

struct ToolBars: ToolbarContent {
    let add: () -> Void
    let sort: () -> Void
    let filter: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button("Add", action: add)
        }
        
        ToolbarItemGroup(placement: .status) {
            Button("Sort", action: sort)
            Button("Filter", action: filter)
        }
    }
}

