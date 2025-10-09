//
//  GeneralSettingsView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 6.10.2025.
//

import SwiftUI

struct GeneralSettingsView: View {
    @State private var selectedLayout: InputLayout = FeatureManager.shared.inputLayout
    @ObservedObject private var featureManager = FeatureManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            SettingsSection(title: "Launch Settings") {
                VStack(alignment: .leading, spacing: 8) {
                    Toggle("Launch on system startup", isOn: $featureManager.launchOnStart)
                        .toggleStyle(.switch)
                    
                    Text("The app will automatically start when you log in to your Mac.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            SettingsSection(title: "Input Layout") {
                VStack(alignment: .leading, spacing: 10) {
                    Picker("Layout Style \t", selection: $selectedLayout) {
                        ForEach(InputLayout.allCases, id: \.self) { layout in
                            Label(layout.displayName, systemImage: layout.iconName)
                                .tag(layout)
                        }
                    }
                    .pickerStyle(.inline)
                    .onChange(of: selectedLayout) {
                        featureManager.inputLayout = selectedLayout
                    }
                    
                    Text(selectedLayout.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .animation(.default, value: selectedLayout)
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
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(nsColor: .controlBackgroundColor).opacity(0.5)))
        }
    }
}
