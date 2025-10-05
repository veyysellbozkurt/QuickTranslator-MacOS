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
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func hideSettings() {
        settingsWindow?.orderOut(nil)
        isSettingsOpen = false
        updateDockIconVisibility()
    }
    
    private func createSettingsWindow() {
        // Tek coordinator instance
        let coordinator = PreferencesContainerView.Coordinator()
        let container = PreferencesContainerView(windowManager: self, selection: coordinator)
        
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

// MARK: - Preferences Container View
struct PreferencesContainerView: View {
    let windowManager: SettingsWindowManager
    @ObservedObject var selection: Coordinator
    
    class Coordinator: NSObject, ObservableObject {
        @Published var index: Int = 0
        
        @objc func selectGeneral() { index = 0 }
        @objc func selectTranslation() { index = 1 }
        @objc func selectShortcuts() { index = 2 }
        @objc func selectAbout() { index = 3 }
    }
    
    func contentView(selection: Coordinator) -> some View {
        Group {
            switch selection.index {
                case 0: GeneralSettingsView()
                case 1: TranslationSettingsView()
                case 2: ShortcutsSettingsView()
                case 3: AboutSettingsView(windowManager: windowManager)
                default: GeneralSettingsView()
            }
        }
    }
    
    var body: some View {
        let tabs: [TabItem] = [
            .init(label: "General", systemImageName: "gear"),
            .init(label: "Translation", systemImageName: "globe"),
            .init(label: "Shortcuts", systemImageName: "keyboard"),
            .init(label: "About", systemImageName: "info.circle"),            
        ]
        
        VStack {
            CustomTabBar(tabs: tabs, selectedIndex: $selection.index)
            Divider()
            contentView(selection: selection)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
