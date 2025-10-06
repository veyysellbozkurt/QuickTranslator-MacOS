//
//  AboutSettingsView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 6.10.2025.
//

import SwiftUI


struct AboutSettingsView: View {
    let windowManager: SettingsWindowManager
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "globe.badge.chevron.backward")
                .font(.system(size: 64))
                .foregroundColor(.app)
            
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
        .padding(20)
    }
}
