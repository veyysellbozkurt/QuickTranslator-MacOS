//
//  FontManager.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 24.10.2025.
//

import SwiftUI
import AppKit

final class FontManager {
    
    static let shared = FontManager()
    
    private init() {}
    
    // MARK: - SwiftUI Font Helpers
    func swiftUIFont(weight: FontWeight = .regular, size: CGFloat) -> Font {
        let name = fontName(weight: weight)
        return Font.custom(name, size: size)
//        return Font.custom("dd", size: size)
    }
    
    // MARK: - AppKit Font Helpers
    func nsFont(weight: FontWeight = .medium, size: CGFloat) -> NSFont {
        let name = fontName(weight: weight)
        if let font = NSFont(name: name, size: size) {
            return font
        } else {
            print("⚠️ Font not found: \(name)")
            return NSFont.systemFont(ofSize: size)
        }
    }
    
    // MARK: - Font Name Resolver (PostScript Names)
    private func fontName(weight: FontWeight) -> String {
        switch weight {
        case .thin:         return "Poppins-Thin"
        case .light:        return "Poppins-Light"
        case .extraLight:   return "Poppins-ExtraLight"
        case .regular:      return "Poppins-Regular"
        case .medium:       return "Poppins-Medium"
        case .semibold:     return "Poppins-SemiBold"
        case .bold:         return "Poppins-Bold"
        case .extraBold:    return "Poppins-ExtraBold"
        case .black:        return "Poppins-Black"
        }
    }
    
    // MARK: - Nested Types
    enum FontWeight {
        case thin, light, extraLight, regular, medium, semibold, bold, extraBold, black
    }
}
