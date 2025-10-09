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
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 200),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.title = "Preferences"
        window.isReleasedWhenClosed = false
        
        let visualEffectView = NSVisualEffectView(frame: window.contentView!.bounds)
        visualEffectView.autoresizingMask = [.width, .height]
        visualEffectView.blendingMode = .behindWindow
        visualEffectView.material = .sidebar
        visualEffectView.state = .followsWindowActiveState
        
        hostingController!.view.frame = visualEffectView.bounds
        hostingController!.view.autoresizingMask = [.width, .height]
        visualEffectView.addSubview(hostingController!.view)
        window.contentView = visualEffectView
        
        settingsWindow = window
        windowDelegate = SettingsWindowDelegate(manager: self)
        window.delegate = windowDelegate
    }
    
    func updateWindowSize(animated: Bool = true) {
        guard let window = settingsWindow,
              let hostingView = window.contentView?.subviews.first(where: { $0 is NSHostingView<AnyView> })
              ?? window.contentView?.subviews.first
        else { return }

        let targetSize = hostingView.fittingSize

        let currentFrame = window.frame
        let newHeight = max(targetSize.height, 200) // minimum height
        let newWidth = max(targetSize.width, 400)   // minimum width

        // Üst köşeyi sabit tutmak için y-origin'i hesapla
        let deltaHeight = newHeight - currentFrame.height
        let newOrigin = NSPoint(x: currentFrame.origin.x,
                                y: currentFrame.origin.y - deltaHeight)

        if animated {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.25
                window.animator().setFrame(NSRect(x: newOrigin.x,
                                                  y: newOrigin.y,
                                                  width: newWidth,
                                                  height: newHeight), display: true)
            }
        } else {
            window.setFrame(NSRect(x: newOrigin.x,
                                   y: newOrigin.y,
                                   width: newWidth,
                                   height: newHeight), display: true)
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
