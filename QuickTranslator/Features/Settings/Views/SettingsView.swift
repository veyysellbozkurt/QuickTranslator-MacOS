//
//  SettingsView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 17.09.2025.
//

import SwiftUI

struct SettingsView: View {
    let windowManager: SettingsWindowManager

    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }

            TranslationSettingsView()
                .tabItem {
                    Label("Translation", systemImage: "globe")
                }

            ShortcutsSettingsView()
                .tabItem {
                    Label("Shortcuts", systemImage: "keyboard")
                }

            AboutSettingsView(windowManager: windowManager)
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
        .frame(width: 500, height: 400)
        .padding()
        .background(.ultraThinMaterial)
    }
}

// MARK: - General Settings Tab
struct GeneralSettingsView: View {
    @State private var launchAtLogin = false
    @State private var showNotifications = true
    @State private var autoCopyTranslation = false
    @State private var enableSoundEffects = true
    
    var body: some View {
        Form {
            Section(header: Text("Application")) {
                Toggle("Launch at login", isOn: $launchAtLogin)
                Toggle("Show notifications", isOn: $showNotifications)
                Toggle("Auto-copy translation", isOn: $autoCopyTranslation)
                Toggle("Enable sound effects", isOn: $enableSoundEffects)
            }
            
            Section(header: Text("Appearance")) {
                Picker("Theme", selection: .constant("System")) {
                    Text("System").tag("System")
                    Text("Light").tag("Light")
                    Text("Dark").tag("Dark")
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Slider(value: .constant(0.95), in: 0.5...1.0, step: 0.05) {
                    Text("Opacity")
                } minimumValueLabel: {
                    Text("50%")
                } maximumValueLabel: {
                    Text("100%")
                }
            }
        }
        .formStyle(.grouped)
        .padding()
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
        Form {
            Section(header: Text("Languages")) {
                Picker("Default source language", selection: $sourceLanguage) {
                    Text("Auto Detect").tag("Auto")
                    Text("English").tag("en")
                    Text("Turkish").tag("tr")
                    Text("German").tag("de")
                    Text("French").tag("fr")
                    Text("Spanish").tag("es")
                }
                
                Picker("Default target language", selection: $targetLanguage) {
                    Text("Turkish").tag("tr")
                    Text("English").tag("en")
                    Text("German").tag("de")
                    Text("French").tag("fr")
                    Text("Spanish").tag("es")
                }
                
                Picker("Translation provider", selection: $translationProvider) {
                    Text("Google Translate").tag("Google")
                    Text("DeepL").tag("DeepL")
                    Text("Microsoft Translator").tag("Microsoft")
                }
            }
            
            Section(header: Text("History")) {
                Toggle("Enable translation history", isOn: $enableHistory)
                if enableHistory {
                    Stepper("Maximum history items: \(maxHistoryItems)", value: $maxHistoryItems, in: 10...500, step: 10)
                }
                Button("Clear History") {
                    // Clear history
                }
            }
        }
        .formStyle(.grouped)
        .padding()
    }
}

// MARK: - Shortcuts Settings Tab
struct ShortcutsSettingsView: View {
    var body: some View {
        Form {
            Section(header: Text("Global Shortcuts")) {
                HStack {
                    Text("Quick translate:")
                    Spacer()
                    Text("⌘ + ⇧ + T")
                        .font(.system(.body, design: .monospaced))
                        .padding(4)
                        .background(Color.secondary.opacity(0.2))
                        .cornerRadius(4)
                }
                HStack {
                    Text("Show/Hide window:")
                    Spacer()
                    Text("⌃ + Space")
                        .font(.system(.body, design: .monospaced))
                        .padding(4)
                        .background(Color.secondary.opacity(0.2))
                        .cornerRadius(4)
                }
                HStack {
                    Text("Translate clipboard:")
                    Spacer()
                    Text("⌘ + ⌥ + T")
                        .font(.system(.body, design: .monospaced))
                        .padding(4)
                        .background(Color.secondary.opacity(0.2))
                        .cornerRadius(4)
                }
            }
        }
        .formStyle(.grouped)
        .padding()
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
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
