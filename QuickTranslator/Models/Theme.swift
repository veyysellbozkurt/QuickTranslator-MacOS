//
//  Theme.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 26.10.2025.
//

import AppKit

enum Theme: Codable {
    case light
    case dark
    
    var nsAppearanceName: NSAppearance.Name {
        switch self {
        case .dark: return .darkAqua
        case .light: return .aqua
        }
    }
}
