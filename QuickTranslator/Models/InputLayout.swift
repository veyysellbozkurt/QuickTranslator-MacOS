//
//  InputLayout.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 10.10.2025.
//

import Foundation
import CoreGraphics

enum InputLayout: String, Codable, CaseIterable {
    case vertical
    case horizontal
}

extension InputLayout: Identifiable {
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .horizontal: return "Horizontal"
        case .vertical: return "Vertical"
        }
    }
    
    var iconName: String {
        switch self {
        case .horizontal: return "rectangle.split.2x1"
        case .vertical: return "rectangle.split.1x2"
        }
    }
    
    var description: String {
        switch self {
        case .horizontal:
            return "Inputs will appear side by side."
        case .vertical:
            return "Inputs will appear stacked vertically."
        }
    }
    
    var minHeight: CGFloat {
        switch self {
        case .horizontal:
            return 260
        case .vertical:
            return 300
        }
    }
    
    var maxHeight: CGFloat {
        switch self {
        case .horizontal:
            return 550
        case .vertical:
            return 600
        }
    }
    
    var baseWidth: CGFloat {
        switch self {
        case .horizontal:
            return 500
        case .vertical:
            return 400
        }
    }
}
