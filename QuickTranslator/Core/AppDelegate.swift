//
//  AppDelegate.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 18.08.2025.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        DIContainer.shared.quickActionManager.start()
        
        NSApp.setActivationPolicy(.accessory)
        
        performShortAfter {
//            DIContainer.shared.settingsWindowManager.showSettings()
            DIContainer.shared.mainPopover.show(from: DIContainer.shared.statusBarController.statusItem.button!)
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
