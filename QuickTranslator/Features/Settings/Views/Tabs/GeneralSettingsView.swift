//
//  GeneralSettingsView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 6.10.2025.
//

import SwiftUI

struct GeneralSettingsView: View {
    @State private var launchAtLogin = false
    @State private var showNotifications = true
    @State private var autoCopyTranslation = false
    @State private var enableSoundEffects = true
    @State private var theme = "System"
    @State private var opacity: Double = 0.95
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                SettingsSection(title: "Application") {
                    SettingsToggle(title: "Launch at login", isOn: $launchAtLogin)
                    SettingsToggle(title: "Show notifications", isOn: $showNotifications)
                    SettingsToggle(title: "Auto-copy translation", isOn: $autoCopyTranslation)
                    SettingsToggle(title: "Enable sound effects", isOn: $enableSoundEffects)
                }
                
                SettingsSection(title: "Appearance") {
                    SettingsPicker(
                        title: "Theme",
                        selection: $theme,
                        options: ["System", "Light", "Dark"]
                    )
                    
                    SettingsSlider(
                        title: "Opacity",
                        value: $opacity,
                        range: 0.5...1.0,
                        step: 0.05,
                        minLabel: "50%",
                        maxLabel: "100%"
                    )
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
