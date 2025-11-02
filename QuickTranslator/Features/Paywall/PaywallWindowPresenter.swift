//
//  PaywallWindowPresenter.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 30.10.2025.
//

import AppKit
import SwiftUI

final class PaywallWindowPresenter: ObservableObject {
    
    @Published private var isPaywallOpen = false
    
    private var paywallWindow: NSWindow?
    private var windowDelegate: PaywallWindowDelegate?
    private var hostingController: NSHostingController<PaywallView>?

    func openPaywall() {
        if paywallWindow == nil {
            createPaywallWindow()
        }

        isPaywallOpen = true
        updateDockIconVisibility()

        if let window = paywallWindow {
            window.makeKeyAndOrderFront(nil)
            window.center()
            window.orderFrontRegardless()
            window.makeKey()
        }

        NSApp.activate(ignoringOtherApps: true)
    }
    
    func closePaywall() {
        isPaywallOpen = false
        updateDockIconVisibility()
    }
    
    private func createPaywallWindow() {
        let contentView = PaywallView()
        hostingController = NSHostingController(rootView: contentView)
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 630, height: 700),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
                
        window.isReleasedWhenClosed = false
        window.backgroundColor = .clear
        window.isMovableByWindowBackground = true
        
        hostingController!.view.frame = window.contentView!.bounds
        hostingController!.view.autoresizingMask = [.width, .height]
        hostingController!.view.wantsLayer = true
        hostingController!.view.layer?.cornerRadius = 12
        hostingController!.view.layer?.masksToBounds = true
        window.contentView = hostingController!.view
        
        windowDelegate = PaywallWindowDelegate(manager: self)
        window.delegate = windowDelegate
        paywallWindow = window
    }
    
    private func updateDockIconVisibility() {
        DispatchQueue.main.async {
            if self.isPaywallOpen {
                NSApp.setActivationPolicy(.regular)
            } else {
                NSApp.setActivationPolicy(.accessory)
            }
        }
    }
}

// MARK: - Window Delegate
class PaywallWindowDelegate: NSObject, NSWindowDelegate {
    private let manager: PaywallWindowPresenter
    
    init(manager: PaywallWindowPresenter) {
        self.manager = manager
    }
    
    func windowWillClose(_ notification: Notification) {
        manager.closePaywall()
    }
}
