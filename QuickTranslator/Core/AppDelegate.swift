//
//  AppDelegate.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 18.08.2025.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover: NSPopover!
    @State private var isPinned = false
    private let viewModel = TranslateViewModel()
    private var quickActionController: QuickActionController!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 550)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(
            rootView: VStack {
                TranslateView(viewModel: viewModel)
                PopoverControls(popover: popover)
            }
                .background(Color.accentColor.opacity(0.1))
        )
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            let img = NSImage(resource: .language)
            img.size = NSSize(width: 18, height: 18)
            img.isTemplate = false
            button.image = img
            button.action = #selector(togglePopover(_:))
            button.target = self
        }
        
        quickActionController = QuickActionController(appDelegate: self, viewModel: viewModel)
        quickActionController.start()
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        guard let button = statusItem.button else { return }
        if popover.isShown {
            popover.performClose(sender)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            popover.contentViewController?.view.window?.becomeKey()
        }
    }
}
