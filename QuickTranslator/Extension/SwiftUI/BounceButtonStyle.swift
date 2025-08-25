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
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: configuration.isPressed)
    }
}
