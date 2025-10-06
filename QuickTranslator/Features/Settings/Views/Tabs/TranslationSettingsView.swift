//
//  TranslationSettingsView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 6.10.2025.
//

import SwiftUI

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
    }
}
