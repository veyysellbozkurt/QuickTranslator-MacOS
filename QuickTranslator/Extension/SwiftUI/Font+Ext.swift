//
//  Font+Ext.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 24.10.2025.
//

import SwiftUI

extension Font {
    /// Default weight is `medium`
    static func appFont(_ weight: FontManager.FontWeight = .medium, size: CGFloat) -> Font {
        FontManager.shared.swiftUIFont(weight: weight, size: size)
    }
    
    static func appHeader() -> Font {
        // App ana başlıkları
        FontManager.shared.swiftUIFont(weight: .bold, size: 20)
    }
    
    static func appLargeTitle() -> Font {
        // App ana başlıkları
        FontManager.shared.swiftUIFont(weight: .semibold, size: 16)
    }
    
    static func appTitle() -> Font {
        // Önemli başlıklar
        FontManager.shared.swiftUIFont(weight: .medium, size: 14)
    }
    
    static func appTitleSemibold() -> Font {
        // Önemli başlıklar semibold
        FontManager.shared.swiftUIFont(weight: .semibold, size: 13)
    }
    
    static func appSmallTitle13() -> Font {
        // Önemli başlıklar semibold
        FontManager.shared.swiftUIFont(weight: .medium, size: 13)
    }
    
    static func appSmallTitle() -> Font {
        // Küçük başlıklar / alt başlıklar
        FontManager.shared.swiftUIFont(weight: .medium, size: 12)
    }
    
    static func appCaption() -> Font {
        // Versiyon, açıklamalar, küçük metinler
        FontManager.shared.swiftUIFont(weight: .regular, size: 11)
    }
    
    static func appButton() -> Font {
        // Buton metinleri
        FontManager.shared.swiftUIFont(weight: .medium, size: 14)
    }
}
