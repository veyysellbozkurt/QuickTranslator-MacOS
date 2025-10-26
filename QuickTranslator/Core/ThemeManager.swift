//
//  ThemeManager.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 26.10.2025.
//

import AppKit

final class ThemeManager {
    
    func applyCurrentFeatureTheme() {
        apply(theme: FeatureManager.shared.selectedTheme)
    }
    
    func apply(theme: Theme) {
        let appearanceName: NSAppearance.Name = (theme == .dark) ? .darkAqua : .aqua
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for window in NSApplication.shared.windows {
                window.appearance = NSAppearance(named: appearanceName)
                window.invalidateShadow()
                window.contentView?.needsDisplay = true
            }
        }
    }
    
    var systemTheme: Theme {
        let match = NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua])
        return (match == .darkAqua) ? .dark : .light
    }
}
