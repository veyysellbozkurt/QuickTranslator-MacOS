//
//  AppDelegate.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 18.08.2025.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    static private(set) var shared: AppDelegate!
    lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let menu = ApplicationMenu()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        AppDelegate.shared = self
//        statusBarItem.button?.image = NSImage(systemSymbolName: SFIcons.captionsBubble.rawValue,
//                                              accessibilityDescription: "Quick Translate")
//        statusBarItem.button?.menu = menu.createMenuItem()
    }
}
