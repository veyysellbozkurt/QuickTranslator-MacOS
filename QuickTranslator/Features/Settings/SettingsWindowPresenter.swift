//
//  SettingsWindowPresenter.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 28.08.2025.
//

import SwiftUI
import AppKit

final class SettingsWindowPresenter: ObservableObject {
    
    private var settingsWindow: NSWindow?
    private var windowDelegate: SettingsWindowDelegate?
    @Published private var isSettingsOpen = false
    
    func openSettings() {
        if settingsWindow == nil {
            createSettingsWindow()
        }
        
        isSettingsOpen = true
        updateDockIconVisibility()
        
        if let window = settingsWindow {
            window.makeKeyAndOrderFront(nil)
            window.center()
            window.orderFrontRegardless()
            window.makeKey()
        }
                                
        NSApp.activate(ignoringOtherApps: true)
        DIContainer.shared.themeManager.applyCurrentFeatureTheme()
    }
    
    func closeSettings() {
        isSettingsOpen = false
        updateDockIconVisibility()
    }
    
    private var hostingController: NSHostingController<SettingsContainerView>?

    private func createSettingsWindow() {
        let coordinator = SettingsContainerView.Coordinator(manager: self)
        let container = SettingsContainerView(windowManager: self, selection: coordinator)
        
        hostingController = NSHostingController(rootView: container)
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 500),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        
        window.title = "Preferences"
        window.titlebarAppearsTransparent = true
        window.isReleasedWhenClosed = false
        window.backgroundColor = .appWindowBackground
        window.isMovableByWindowBackground = true
        
        hostingController!.view.frame = window.contentView!.bounds
        hostingController!.view.autoresizingMask = [.width, .height]
        window.contentView = hostingController!.view
        
        windowDelegate = SettingsWindowDelegate(manager: self)
        window.delegate = windowDelegate
        settingsWindow = window
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
    private let manager: SettingsWindowPresenter
    
    init(manager: SettingsWindowPresenter) {
        self.manager = manager
    }
    
    func windowWillClose(_ notification: Notification) {
        manager.closeSettings()
    }
}
