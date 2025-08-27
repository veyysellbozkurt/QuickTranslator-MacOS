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
                Image(systemName: isPinned ? "pin.fill" : "pin")
                    .resizable()
            }
            .frame(width: 16, height: 24)
            .buttonStyle(BounceButtonStyle())

            Spacer()
            
            Button {
                NSApp.terminate(nil)
            } label: {
                Label("Quit", systemImage: "power")
                    .contentShape(Rectangle())
            }
            .font(.title3)
            .buttonStyle(BounceButtonStyle())
        }
        .padding([.horizontal, .bottom])
    }
}
