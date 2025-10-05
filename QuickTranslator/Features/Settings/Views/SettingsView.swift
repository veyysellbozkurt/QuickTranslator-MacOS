//
//  SettingsView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 17.09.2025.
//

import SwiftUI

// MARK: - General Settings Tab
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
//        .background(Color(nsColor: .windowBackgroundColor))
//        .background(Color.app.opacity(0.45))
    }
}

// MARK: - Translation Settings Tab
struct TranslationSettingsView: View {
    @State private var sourceLanguage = "Auto"
    @State private var targetLanguage = "tr"
    @State private var enableHistory = true
    @State private var maxHistoryItems = 50
    @State private var translationProvider = "Google"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                SettingsSection(title: "Languages") {
//                    SettingsPicker(title: "Default source language", selection: $sourceLanguage, options: ["Auto", "English", "Turkish", "German", "French", "Spanish"])
//                    
//                    SettingsPicker(title: "Default target language", selection: $targetLanguage, options: ["Turkish", "English", "German", "French", "Spanish"])
//                    
//                    SettingsPicker(title: "Translation provider", selection: $translationProvider, options: ["Google", "DeepL", "Microsoft"])
                }
                
                SettingsSection(title: "History") {
                    SettingsToggle(title: "Enable translation history", isOn: $enableHistory)
                    
                    if enableHistory {
                        SettingsStepper(title: "Maximum history items", value: $maxHistoryItems, range: 10...500, step: 10)
                    }
                    
                    Button("Clear History") {
                        // Clear history
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding(20)
        }
//        .background(Color(nsColor: .windowBackgroundColor))
//        .background(Color.app.opacity(0.45))
    }
}

// MARK: - Shortcuts Settings Tab
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
//        .background(Color(nsColor: .windowBackgroundColor))
//        .background(Color.app.opacity(0.45))
    }
}

// MARK: - About Settings Tab
struct AboutSettingsView: View {
    let windowManager: SettingsWindowManager
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "globe.badge.chevron.backward")
                .font(.system(size: 64))
                .foregroundColor(.accentColor)
            
            VStack(spacing: 4) {
                Text("Quick Translator").font(.title).bold()
                Text("Version 1.0.0").font(.subheadline).foregroundColor(.secondary)
                Text("Build 2025.09.17").font(.caption).foregroundColor(.secondary)
            }
            
            Text("A fast and efficient translation tool for macOS.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Spacer()
            
            HStack(spacing: 16) {
                Button("Support") {
                    if let url = URL(string: "https://buymeacoffee.com/yourapp") {
                        NSWorkspace.shared.open(url)
                    }
                }.buttonStyle(.bordered)
                
                Button("GitHub") {
                    if let url = URL(string: "https://github.com/yourusername/quick-translator") {
                        NSWorkspace.shared.open(url)
                    }
                }.buttonStyle(.bordered)
                
                Button("Close") {
                    windowManager.hideSettings()
                }.buttonStyle(.borderedProminent)
            }
        }
//        .background(Color.app.opacity(0.45))
        .padding(20)
    }
}

// MARK: - Reusable Custom Components

struct SettingsSection<Content: View>: View {
    let title: String
    let content: () -> Content
    
    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title.uppercased())
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            
            VStack(alignment: .leading, spacing: 10) {
                content()
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(nsColor: .controlBackgroundColor)))
        }
    }
}

struct SettingsToggle: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
    }
}

struct SettingsPicker: View {
    let title: String
    @Binding var selection: String
    let options: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Picker("", selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 220)
        }
    }
}

struct SettingsSlider: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let minLabel: String
    let maxLabel: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Slider(value: $value, in: range, step: step)
                .frame(width: 220)
            HStack {
                Text(minLabel)
                Spacer()
                Text(maxLabel)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }
}

struct SettingsStepper: View {
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let step: Int
    
    var body: some View {
        HStack {
            Text("\(title): \(value)")
            Spacer()
            Stepper("", value: $value, in: range, step: step)
                .labelsHidden()
        }
    }
}

struct SettingsShortcut: View {
    let title: String
    let keys: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(keys)
                .font(.system(.body, design: .monospaced))
                .padding(4)
                .background(Color.secondary.opacity(0.2))
                .cornerRadius(4)
        }
    }
}
