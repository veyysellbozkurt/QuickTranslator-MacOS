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
            launchSettingsSection
            inputLayoutSection
            menuBarIconSection
            quitSection
        }
        .padding()
    }
}

extension GeneralSettingsView {
    
    // MARK: - Launch Settings
    private var launchSettingsSection: some View {
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
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    // MARK: - Input Layout
    private var inputLayoutSection: some View {
        SettingsSection(title: "Input Layout") {
            VStack(alignment: .leading, spacing: 10) {
                Picker("Layout Style", selection: $featureManager.inputLayout) {
                    ForEach(InputLayout.allCases, id: \.self) { layout in
                        Label(layout.displayName, systemImage: layout.iconName)
                            .tag(layout)
                    }
                }
                .tint(.app)
                .pickerStyle(.inline)
                
                Text(featureManager.inputLayout.description)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .animation(.default, value: featureManager.inputLayout)
            }
        }
    }
    
    // MARK: - Menu Bar Icon
    private var menuBarIconSection: some View {
        SettingsSection(title: "Menu Bar Icon") {
            Text("The app will automatically start when you log in to your Mac.")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 20) {
                ForEach(MenuBarIconEnum.allCases, id: \.self) { icon in
                    menuBarIconButton(for: icon)
                }
            }
        }
    }
    
    private func menuBarIconButton(for icon: MenuBarIconEnum) -> some View {
        Button(action: {
            withAnimation(.interpolatingSpring(stiffness: 200, damping: 18)) {
                featureManager.menuBarIcon = icon
            }
        }) {
            VStack(spacing: 6) {
                Image(nsImage: icon.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .cornerRadius(8)
                    .padding(.horizontal, 6)

                Text(icon.rawValue.capitalized)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(featureManager.menuBarIcon == icon
                          ? Color.accentColor.opacity(0.2)
                          : Color.clear)
            )
        }
        .buttonStyle(.plain)
        .id(featureManager.menuBarIcon == icon)

        .onHover { hovering in
            if hovering {
                NSCursor.pointingHand.push()
            } else {
                NSCursor.pop()
            }
        }
    }
    
    // MARK: - Quit
    private var quitSection: some View {
        SettingsSection(title: "Quit") {
            Button(action: { NSApp.terminate(nil) }) {
                Text("Quit QuickTranslator")
            }
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.app)
            .controlSize(.regular)
        }
    }
}

// MARK: - Shared Section Component
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
