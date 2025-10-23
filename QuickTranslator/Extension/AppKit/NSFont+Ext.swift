//
//  Font+Ext.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 24.10.2025.
//

import AppKit

extension NSFont {
    /// Default weight is `medium`
    static func appFont(_ weight: FontManager.FontWeight = .medium, size: CGFloat) -> NSFont {
        return FontManager.shared.nsFont(weight: weight, size: size)
    }
}
