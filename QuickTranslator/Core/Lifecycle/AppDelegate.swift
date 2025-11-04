//
//  AppDelegate.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 18.08.2025.
//

import SwiftUI
import RevenueCat

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        DIContainer.shared.quickActionManager.start()
        
        Task { @MainActor in
            SubscriptionManager.shared.configure()
            await SubscriptionManager.shared.checkSubscriptionStatusIfNeeded()
        }
        performAfter(2) {
            DIContainer.shared.paywallWindowPresenter.openPaywall()
        }
    }
    
    /// When clicking the app icon in the Dock
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        return true
    }
        
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}
