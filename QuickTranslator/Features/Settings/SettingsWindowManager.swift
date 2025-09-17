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
        visualEffectView.blendingMode = .behindWindow
        visualEffectView.material = .sidebar // istediğin materyal: .hudWindow, .menu, .sidebar vs.
        visualEffectView.state = .active
        
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
        @Published var selection: Int = 0
        
        @objc func selectGeneral() { selection = 0 }
        @objc func selectTranslation() { selection = 1 }
        @objc func selectShortcuts() { selection = 2 }
        @objc func selectAbout() { selection = 3 }
    }
    
    func contentView(selection: Coordinator) -> some View {
        Group {
            switch selection.selection {
                case 0: GeneralSettingsView()
                case 1: TranslationSettingsView()
                case 2: ShortcutsSettingsView()
                case 3: AboutSettingsView(windowManager: windowManager)
                default: GeneralSettingsView()
            }
        }
    }
    
    var body: some View {
        VStack {
            CustomTabBar(selection: selection, windowManager: windowManager)
            Divider()
            contentView(selection: selection)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct CustomTabBar: View {
    @ObservedObject var selection: PreferencesContainerView.Coordinator
    let windowManager: SettingsWindowManager
    
    let tabs: [(label: String, systemImage: String)] = [
        ("General", "gear"),
        ("Translation", "globe"),
        ("Shortcuts", "keyboard"),
        ("About", "info.circle")
    ]
    
    @State private var hoveringIndex: Int? = nil
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<tabs.count, id: \.self) { index in
                let tab = tabs[index]
                Button(action: {
                    selection.selection = index
                }) {
                    VStack {
                        Image(systemName: tab.systemImage)
                            .font(.system(size: 18))
                        Spacer()
                        Text(tab.label)
                            .font(.caption)
                    }
                    .foregroundColor(selection.selection == index ? .white : .primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(
                                selection.selection == index ? Color.gray.opacity(0.4) :
                                    hoveringIndex == index ? Color.gray.opacity(0.2) :
                                    Color.clear
                            )
                    )
                }
                .buttonStyle(.plain)
                .onHover { hovering in
                    hoveringIndex = hovering ? index : nil
                }
            }
        }
        .frame(width: 250, height: 24)
        .background(Color.clear)
        .padding(.bottom)
    }
}
