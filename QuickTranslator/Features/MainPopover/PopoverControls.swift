//
//  PopoverControls.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 26.08.2025.
//

import SwiftUI

struct PopoverControls: View {
    @State private var isPinned = false
    var popover: NSPopover

    var body: some View {
        HStack {
            Button {
                isPinned.toggle()
                popover.behavior = isPinned ? .applicationDefined : .transient
            } label: {
                Image(systemName: isPinned ? SFIcons.pinFill : SFIcons.pin)
                    .resizable()
                    .foregroundStyle(isPinned ? .app : .secondary)
            }
            .frame(width: 12, height: 18)
            .buttonStyle(BounceButtonStyle())
            
            Spacer()
            
            HStack(spacing: 14) {
                Button {
                    NSApp.terminate(nil)
                } label: {
                    Image(.power)
                        .resizable()
                        .foregroundStyle(.secondary)
                }
                .frame(width: 17, height: 17)
                .buttonStyle(BounceButtonStyle())
                
                Button {
                    DIContainer.shared.settingsWindowManager.showSettings()
                } label: {
                    Image(.settings)
                        .resizable()
                        .foregroundStyle(.secondary)
                }
                .frame(width: 17, height: 17)
                .buttonStyle(BounceButtonStyle())
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 32)
        .background(Color.secondary.opacity(0.07))
    }
}
