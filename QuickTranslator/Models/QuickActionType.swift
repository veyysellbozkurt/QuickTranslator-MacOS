//
//  QuickActionType.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 11.10.2025.
//

import Foundation

enum QuickActionType: String, CaseIterable, Codable {
    case floatingIconPopover
    case directPopover
    
    var displayName: String {
        switch self {
            case .directPopover: return "Open Translate Window"
            case .floatingIconPopover: return "Show Floating Icon"
        }
    }
    
    var iconName: String {
        switch self {
            case .directPopover: return "text.bubble"
            case .floatingIconPopover: return "circle.dashed"
        }
    }
}
