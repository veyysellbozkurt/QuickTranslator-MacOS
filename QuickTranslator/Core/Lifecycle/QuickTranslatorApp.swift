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
        }
        .commands {
            CommandGroup(replacing: .appSettings) {
                Button("Settings…") {
                    DIContainer.shared.settingsWindowPresenter.openSettings()
                }
                .keyboardShortcut(",", modifiers: .command)
            }
        }
    }
}
