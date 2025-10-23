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
    
    // MARK: - Font Ailesi
    private let defaultFamily = "Inter"
    
    // MARK: - SwiftUI Font Helpers
    func swiftUIFont(weight: FontWeight = .regular, size: CGFloat) -> Font {
        let name = fontName(weight: weight)
        return Font.custom(name, size: size)
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
        case .light:   return "Inter-Light"
        case .regular: return "Inter-Regular"
        case .medium:  return "Inter-Medium"
        case .semibold:return "Inter-SemiBold"
        case .bold:    return "Inter-Bold"
        }
    }
    
    // MARK: - Nested Types
    enum FontWeight {
        case light, regular, medium, semibold, bold
    }
}
