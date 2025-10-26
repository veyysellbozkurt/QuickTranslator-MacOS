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
        }
        .padding()
        .frame(height: 400)
    }
}

extension GeneralSettingsView {
    
    // MARK: - Launch Settings
    private var launchSettingsSection: some View {
        SettingsSection(title: Constants.Strings.launchSettingsTitle) {
            VStack(alignment: .leading, spacing: 8) {
                Toggle(Constants.Strings.launchOnStartup, isOn: $launchOnStart)
                    .toggleStyle(.switch)
                    .font(.appSmallTitle())
                    .tint(.app)
                    .onChange(of: launchOnStart) {
                        featureManager.launchOnStart = launchOnStart
                        manager.toggleLaunchAtLogin()
                    }
                
                Text(Constants.Strings.launchOnStartupDescription)
                    .font(.appCaption())
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    // MARK: - Input Layout
    private var inputLayoutSection: some View {
        SettingsSection(title: Constants.Strings.inputLayoutTitle) {
            VStack(alignment: .leading, spacing: 10) {
                Picker("Layout Style", selection: $featureManager.inputLayout) {
                    ForEach(InputLayout.allCases, id: \.self) { layout in
                        Label(layout.displayName, systemImage: layout.iconName)
                            .tag(layout)
                            .font(.appSmallTitle())
                    }
                }
                .font(.appSmallTitle())
                .tint(.app)
                .pickerStyle(.inline)
                
                Text(featureManager.inputLayout.description)
                    .font(.appCaption())
                    .foregroundStyle(.secondary)
                    .animation(.default, value: featureManager.inputLayout)
            }
        }
    }
    
    // MARK: - Menu Bar Icon
    private var menuBarIconSection: some View {
        SettingsSection(title: Constants.Strings.menuBarIconTitle) {
            HStack(spacing: 20) {
                ForEach(MenuBarIconEnum.allCases, id: \.self) { icon in
                    menuBarIconButton(for: icon)
                }
            }
            
            Text(Constants.Strings.menuBarIconDescription)
                .font(.appCaption())
                .foregroundStyle(.secondary)
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
                    .frame(width: 30, height: 30)
                    .cornerRadius(8)
                    .padding(.horizontal, 6)

                Text(icon.rawValue.capitalized)
                    .font(.appCaption())
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
                .font(.appFont(.semibold, size: 11))
                .foregroundStyle(.secondary)
            
            VStack(alignment: .leading) {
                content()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.08))
                    .strokeBorder(.gray.opacity(0.1), lineWidth: 2)
            )
        }
    }
}
