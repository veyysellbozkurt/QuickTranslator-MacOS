//
//  BounceButtonStyle.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 25.08.2025.
//

import SwiftUI

struct BounceButtonStyle: ButtonStyle {
    var scaleAmount: CGFloat = 0.9
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
                    .scaleEffect(configuration.isPressed ? scaleAmount : 1.0)
                    .animation(
                        .interpolatingSpring(stiffness: 300, damping: 15),
                        value: configuration.isPressed
                    )
    }
}
