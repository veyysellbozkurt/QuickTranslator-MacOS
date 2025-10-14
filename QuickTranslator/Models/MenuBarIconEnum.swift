//
//  MenuBarIconEnum.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 15.10.2025.
//

import Foundation
import AppKit

enum MenuBarIconEnum: String {
    case light
    case blue
    
    var image: NSImage {
        switch self {
            case .light:
                return NSImage(resource: .menuBarIcon1)
            case .blue:
                return NSImage(resource: .menuBarIcon2)
        }
    }
    
    
}
