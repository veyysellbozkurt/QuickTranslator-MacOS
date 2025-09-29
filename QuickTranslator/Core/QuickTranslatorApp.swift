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
        Settings {
            SettingsView(windowManager: DIContainer.shared.settingsWindowManager)
                .frame(width: 500)
                .fixedSize(horizontal: false, vertical: true)
                .background(.thinMaterial)
                .makeSettingsVibrant()
        }
        .windowStyle(.hiddenTitleBar)
    }
}
