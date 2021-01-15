//
//  SGammaPicker.swift
//  NiP
//
//  Created by Dr. Owen Hildreth (Admin) on 1/15/21.
//

import SwiftUI

struct SGammaPicker: View {
    @Binding var sGammaParameter: StageSGammaParameters
    
    var body: some View {
        Picker("Vec. & Acc.", selection: $sGammaParameter) {
            ForEach(StageSGammaParameters.allCases) { setting in
                Text(setting.displayString())
                    .tag(setting as StageSGammaParameters)
            }
        }
    }
}

/**
struct SGammaPicker_Previews: PreviewProvider {
    static var previews: some View {
        
        let controller = StageGroupController()
        @ObservedObject var stage = controller.x
        
        
        SGammaPicker(sGammaParameter: $stage.currentStageSGammaParameters)
        
    }
}
 */
