//
//  View+Ext.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 18.09.2025.
//

import SwiftUI

extension View {
    func makeSettingsVibrant() -> some View {
        self.background(WindowAccessor { window in
            guard let window else { return }
            window.titlebarAppearsTransparent = true
            window.isOpaque = false
            window.backgroundColor = .clear
        })
    }
}

struct WindowAccessor: NSViewRepresentable {
    var callback: (NSWindow?) -> Void
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async { self.callback(view.window) }
        return view
    }
    func updateNSView(_ nsView: NSView, context: Context) {}
}
