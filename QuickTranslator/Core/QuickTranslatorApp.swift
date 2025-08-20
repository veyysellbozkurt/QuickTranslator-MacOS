//
//  QuickTranslatorApp.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 18.08.2025.
//

import SwiftUI
import SwiftData

@main
struct QuickTranslatorApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        MenuBarExtra("Menu Bar Example", systemImage: SFIcons.captionsBubble.rawValue) {
            ContentView()
                .overlay(alignment: .topTrailing) {
                    Button(
                        "Quit",
                        systemImage: "xmark.circle.fill"
                    ) {
                        NSApp.terminate(nil)
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.plain)
                    .padding(6)
                }
                .frame(width: 400, height: 400)
        }
        .menuBarExtraStyle(.window)
    }
}
