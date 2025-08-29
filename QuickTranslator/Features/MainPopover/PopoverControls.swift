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
                NSWorkspace.shared.open(URL(string: "https://buymeacoffee.com/veyselbozkurt")!)
            } label: {
                Image(.buyMeCoffee)
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: 200, height: 28)
            .clipShape(.buttonBorder)
            .buttonStyle(BounceButtonStyle())
                
            Spacer()
            
            Button {
                NSApp.terminate(nil)    
            } label: {
                Label(Constants.Strings.quit, systemImage: SFIcons.power)
                    .contentShape(Rectangle())
            }
            .font(.title3)
            .buttonStyle(BounceButtonStyle())
        }
        .padding([.horizontal, .bottom])
    }
}
