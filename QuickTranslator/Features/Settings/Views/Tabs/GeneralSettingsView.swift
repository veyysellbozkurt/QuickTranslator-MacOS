//
//  GeneralSettingsView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 6.10.2025.
//

import SwiftUI

struct GeneralSettingsView: View {
    @ObservedObject private var featureManager = FeatureManager.shared
    @State private var launchOnStart: Bool = FeatureManager.shared.launchOnStart
    @StateObject private var manager = LaunchAtLoginManager()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            SettingsSection(title: "Launch Settings") {
                VStack(alignment: .leading, spacing: 8) {
                    Toggle("Launch on system startup", isOn: $launchOnStart)
                        .toggleStyle(.switch)
                        .tint(.app)
                        .onChange(of: launchOnStart) {
                            featureManager.launchOnStart = launchOnStart
                            manager.toggleLaunchAtLogin()
                        }
                    
                    Text("The app will automatically start when you log in to your Mac.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            SettingsSection(title: "Input Layout") {
                VStack(alignment: .leading, spacing: 10) {
                    Picker("Layout Style \t", selection: $featureManager.inputLayout) {
                        ForEach(InputLayout.allCases, id: \.self) { layout in
                            Label(layout.displayName, systemImage: layout.iconName)
                                .tag(layout)
                        }
                    }
                    .tint(.app)
                    .pickerStyle(.inline)
                    
                    Text(featureManager.inputLayout.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .animation(.default, value: featureManager.inputLayout)
                }
            }
            
            SettingsSection(title: "Quit") {
                Button(action: {
                    NSApp.terminate(nil)
                }) {
                    HStack {
                        Text("Quit QuickTranslator")
                    }
                }
                .buttonStyle(.borderedProminent)
                .foregroundStyle(.app)
                .controlSize(.regular)
            }
        }
        .padding()
    }
}


struct SettingsSection<Content: View>: View {
    let title: String
    let content: () -> Content
    
    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title.uppercased())
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            
            VStack(alignment: .leading) {
                content()
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.08))
            )
        }
    }
}
