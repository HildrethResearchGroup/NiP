//
//  Extension_View_Hidden.swift
//  Test2
//
//  Created by Owen Hildreth on 3/9/21.
//

import SwiftUI

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}
