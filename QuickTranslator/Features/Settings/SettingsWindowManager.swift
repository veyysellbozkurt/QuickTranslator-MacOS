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
                
        NSApp.activate()
    }
    
    func hideSettings() {
        settingsWindow?.orderOut(nil)
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
        
        hostingController!.view.frame = window.contentView!.bounds
        hostingController!.view.autoresizingMask = [.width, .height]
        window.contentView = hostingController!.view
        
        settingsWindow = window
        windowDelegate = SettingsWindowDelegate(manager: self)
        window.delegate = windowDelegate
    }
    
    func updateWindowHeight(to newHeight: CGFloat, animated: Bool = true) {
        guard let window = settingsWindow else { return }
        var frame = window.frame
        let newY = frame.origin.y + (frame.height - newHeight)
        frame.origin.y = newY
        frame.size.height = newHeight
        
        if animated {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.25
                window.animator().setFrame(frame, display: true)
            }
        } else {
            window.setFrame(frame, display: true)
        }
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
