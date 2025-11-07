//
//  MenuBarIconEnum.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 15.10.2025.
//

import Foundation
import AppKit

enum MenuBarIconEnum: String, CaseIterable, Hashable {
    case light
    case blue
    case dark
    case world
    case gray
    
    var image: NSImage {
        switch self {
            case .light:
                return NSImage(resource: .menuBarIcon1)
            case .blue:
                return NSImage(resource: .menuBarIcon2)
            case .dark:
                return NSImage(resource: .menuBarIcon3)
            case .world:
                return NSImage(resource: .menuBarIcon4)
            case .gray:
                return NSImage(resource: .menuBarIcon5)
        }
    }
}
