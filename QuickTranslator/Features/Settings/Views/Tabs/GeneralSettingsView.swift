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
        VStack(alignment: .leading, spacing: 20) {
            launchSettingsSection
            inputLayoutSection
            menuBarIconSection
        }
        .frame(height: 360)
    }
}

extension GeneralSettingsView {
    
    // MARK: - Launch Settings
    private var launchSettingsSection: some View {
        SettingsSection(title: Constants.Strings.launchSettingsTitle,
                        footnote: Constants.Strings.launchOnStartupDescription) {
            VStack(alignment: .leading, spacing: 8) {
                Toggle(Constants.Strings.launchOnStartup, isOn: $launchOnStart)
                    .toggleStyle(.switch)
                    .font(.appSmallTitle13())
                    .tint(.app)
                    .foregroundStyle(.textPrimary)
                    .onChange(of: launchOnStart) {
                        featureManager.launchOnStart = launchOnStart
                        manager.toggleLaunchAtLogin()
                    }
            }
        }
    }
    
    // MARK: - Input Layout
    private var inputLayoutSection: some View {
        SettingsSection(title: Constants.Strings.inputLayoutTitle,
                        footnote: featureManager.inputLayout.description) {            
            CompactSegmentedPicker(
                options: InputLayout.allCases,
                selection: $featureManager.inputLayout,
                iconProvider: \.iconName,
                titleProvider: \.displayName
            )
        }
    }
    
    // MARK: - Menu Bar Icon
    private var menuBarIconSection: some View {
        SettingsSection(title: Constants.Strings.menuBarIconTitle,
                        footnote: Constants.Strings.menuBarIconDescription) {
            HStack(spacing: 12) {
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
                    .frame(width: 30, height: 30)
                    .cornerRadius(8)
                    .padding(.horizontal, 8)
                
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
