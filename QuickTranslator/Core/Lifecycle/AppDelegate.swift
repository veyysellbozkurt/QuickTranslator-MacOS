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
        DIContainer.shared.subscriptionManager.configure()
                
        #if DEBUG
        performShortAfter {
            DIContainer.shared.settingsWindowManager.showSettings()
//            DIContainer.shared.mainPopover.show(from: DIContainer.shared.statusBarController.statusItem.button!)
        }
        #endif
    }
    
    /// When clicking the app icon in the Dock
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        return true
    }
        
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}
