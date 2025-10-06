//
//  SettingsWindowManager.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 28.08.2025.
//

import SwiftUI
import AppKit

// MARK: - Window Manager
final class SettingsWindowManager: ObservableObject {
    
    private var settingsWindow: NSWindow?
    private var windowDelegate: SettingsWindowDelegate?
    @Published var isSettingsOpen = false
    
    func showSettings() {
        if settingsWindow == nil {
            createSettingsWindow()
        }
        
        isSettingsOpen = true
        updateDockIconVisibility()
        
        settingsWindow?.makeKeyAndOrderFront(nil)
        settingsWindow?.center()
        settingsWindow?.contentViewController?.view.window?.becomeKey()
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func hideSettings() {
        settingsWindow?.orderOut(nil)
        isSettingsOpen = false
        updateDockIconVisibility()
    }
    
    private func createSettingsWindow() {        
        let coordinator = SettingsContainerView.Coordinator()
        let container = SettingsContainerView(windowManager: self, selection: coordinator)
        
        // Window
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 400),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.title = "Preferences"
        window.isReleasedWhenClosed = false
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.isOpaque = false
        window.backgroundColor = .clear
        
        let visualEffectView = NSVisualEffectView(frame: window.contentView!.bounds)
        visualEffectView.autoresizingMask = [.width, .height]
        visualEffectView.blendingMode = .withinWindow
        visualEffectView.material = .titlebar
        visualEffectView.state = .followsWindowActiveState
        
        // NSHostingController
        let hostingController = NSHostingController(rootView: container)
        hostingController.view.wantsLayer = true
        hostingController.view.layer?.backgroundColor = .clear
        hostingController.view.frame = visualEffectView.bounds
        hostingController.view.autoresizingMask = [.width, .height]
        
        visualEffectView.addSubview(hostingController.view)
        window.contentView = visualEffectView
        
        // Save references
        settingsWindow = window
        windowDelegate = SettingsWindowDelegate(manager: self)
        window.delegate = windowDelegate
    }
    
    private func updateDockIconVisibility() {
        DispatchQueue.main.async {
            if self.isSettingsOpen {
                NSApp.setActivationPolicy(.regular)
            } else {
                NSApp.setActivationPolicy(.accessory)
            }
        }
    }
}

// MARK: - Window Delegate
class SettingsWindowDelegate: NSObject, NSWindowDelegate {
    private let manager: SettingsWindowManager
    
    init(manager: SettingsWindowManager) {
        self.manager = manager
    }
    
    func windowWillClose(_ notification: Notification) {
        manager.hideSettings()
    }
}
