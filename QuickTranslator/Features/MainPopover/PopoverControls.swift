//
//  PopoverControls.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 26.08.2025.
//

import SwiftUI

struct PopoverControls: View {
    @ObservedObject private var featureManager = FeatureManager.shared
    @State private var isPinned = false
    var popover: NSPopover

    var body: some View {
        HStack {
            HStack(spacing: 16) {
                Button {
                    isPinned.toggle()
                    popover.behavior = isPinned ? .applicationDefined : .transient
                } label: {
                    Image(systemName: isPinned ? SFIcons.pinFill : SFIcons.pin)
                        .resizable()
                        .foregroundStyle(isPinned ? .app : .iconTint)
                }
                .frame(width: 12, height: 18)
                .buttonStyle(BounceButtonStyle())
                
                Button {
                    featureManager.selectedTheme = (featureManager.selectedTheme == .dark) ? .light : .dark
                    DIContainer.shared.themeManager.apply(theme: featureManager.selectedTheme)
                } label: {
                    Image(featureManager.selectedTheme == .dark ? .sun : .moon)
                        .resizable()
                        .foregroundStyle(.iconTint)
                }
                .frame(width: 17, height: 17)
                .buttonStyle(BounceButtonStyle())
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Button {
                    NSApp.terminate(nil)
                } label: {
                    Image(.power)
                        .resizable()
                        .foregroundStyle(.iconTint)
                }
                .frame(width: 17, height: 17)
                .buttonStyle(BounceButtonStyle())
                
                Button {
                    DIContainer.shared.settingsWindowManager.showSettings()
                } label: {
                    Image(.settings)
                        .resizable()
                        .foregroundStyle(.iconTint)
                }
                .frame(width: 17, height: 17)
                .buttonStyle(BounceButtonStyle())
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 34)
        .background(.hoverBackground.opacity(0.4))
    }
}
