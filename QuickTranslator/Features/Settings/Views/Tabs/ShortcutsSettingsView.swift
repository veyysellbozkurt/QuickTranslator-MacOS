//
//  ShortcutsSettingsView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 6.10.2025.
//

import SwiftUI

struct ShortcutsSettingsView: View {
    var body: some View {
        ScrollView {
            SettingsSection(title: "Global Shortcuts") {
                SettingsShortcut(title: "Quick translate", keys: "⌘ + ⇧ + T")
                SettingsShortcut(title: "Show/Hide window", keys: "⌃ + Space")
                SettingsShortcut(title: "Translate clipboard", keys: "⌘ + ⌥ + T")
            }
            .padding(20)
        }
    }
}
