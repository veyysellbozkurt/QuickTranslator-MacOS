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
                    .foregroundStyle(isPinned ? .app : .iconTint)
            }
            .frame(width: 12, height: 18)
            .buttonStyle(BounceButtonStyle())
            
            Spacer()
            
            HStack(spacing: 12) {
                Button {
                    NSApp.terminate(nil)
                } label: {
                    Image(systemName: SFIcons.power)
                        .resizable()
                        .foregroundStyle(.iconTint)
                }
                .frame(width: 16, height: 17)
                .buttonStyle(BounceButtonStyle())
                
                Button {
                    DIContainer.shared.settingsWindowManager.showSettings()
                } label: {
                    Image(systemName: SFIcons.gear)
                        .resizable()
                        .foregroundStyle(.iconTint)
                }
                .frame(width: 20, height: 19)
                .buttonStyle(BounceButtonStyle())
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 34)
        .background(.hoverBackground.opacity(0.4))
    }
}
