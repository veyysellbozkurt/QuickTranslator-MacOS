//
//  AboutSettingsView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 6.10.2025.
//

import SwiftUI

struct AboutSettingsView: View {
    let windowManager: SettingsWindowManager
    
    // MARK: - Bundle Bilgileri
    private var appName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Quick Translator"
    }
    
    private var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Image(.translation3)
                .resizable()
                .foregroundColor(.app)
                .frame(width: 80, height: 80)
            
            VStack(spacing: 4) {
                Text(appName).font(.title).bold()
                Text("Version \(appVersion)").font(.subheadline).foregroundColor(.secondary)
            }
            
            Text("A fast and efficient translation tool for macOS.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Spacer()
            
            HStack(spacing: 16) {
                Button("Support") {
                    if let url = URL(string: "https://buymeacoffee.com/veyselbozkurt") {
                        NSWorkspace.shared.open(url)
                    }
                }.buttonStyle(.bordered)
                
                Button("Send Feedback") {
                    let email = "veyysellbozkrt@gmail.com"
                    let subject = "Feedback for \(appName) v\(appVersion)"
                    if let url = URL(string: "mailto:\(email)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") {
                        NSWorkspace.shared.open(url)
                    }
                }.buttonStyle(.borderedProminent)
            }
        }
        .padding(20)
    }
}
