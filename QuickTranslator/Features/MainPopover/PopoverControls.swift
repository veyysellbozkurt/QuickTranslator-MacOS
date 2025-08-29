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
            }
            .frame(width: 16, height: 24)
            .buttonStyle(BounceButtonStyle())

            Spacer()
            
            Button {
                NSWorkspace.shared.open(Constants.Urls.buyMeCoffee)
            } label: {
                Image(.buyMeCoffee)
                    .resizable()
                    .scaledToFit()
            }
            .frame(height: 30)
            .clipShape(.buttonBorder)
            .buttonStyle(BounceButtonStyle())
            
            Spacer()
            
            Button {
                // show settings window
            } label: {
                Image(systemName: SFIcons.gear)
                    .resizable()
            }
            .frame(width: 26, height: 24)
            .buttonStyle(BounceButtonStyle())

        }
        .padding(.horizontal, 12)
        .frame(height: 44)
        .background(Color.secondary.opacity(0.1))
    }
}
