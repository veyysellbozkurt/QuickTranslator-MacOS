//
//  FloatingQuickActionPanelController.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 27.08.2025.
//

import AppKit

/// It manages the Clipboard -> Floating Panel -> ViewModel/Popover flow
final class FloatingQuickActionManager {
    
    private let clipboardMonitor = ClipboardMonitor()
    private let floatingPanel: FloatingQuickActionPanel
    private let viewModel: TranslateViewModel
    private let popover: MainPopover
    private var copiedText: String?
    
    init(
        viewModel: TranslateViewModel,
        popover: MainPopover,
        panel: FloatingQuickActionPanel = FloatingQuickActionPanel()
    ) {
        self.viewModel = viewModel
        self.popover = popover
        self.floatingPanel = panel
        floatingPanel.actionDelegate = self
    }
    
    func start() {
        clipboardMonitor.onCopy = { [weak self] text in
            guard let self else { return }
            self.copiedText = text
            self.floatingPanel.showNearMouse()
        }
        clipboardMonitor.start(interval: 0.4)
    }
    
    func stop() {
        clipboardMonitor.stop()
    }
}

// MARK: - Floating Quick Action Panel Delegate
extension FloatingQuickActionManager: FloatingQuickActionPanelDelegate {
    func quickActionPanelDidConfirm(_ panel: FloatingQuickActionPanel) {
        if let text = copiedText {
            viewModel.translatedText = ""
            viewModel.inputText = text
            viewModel.triggerTranslation()
        }
        if let button = DIContainer.shared.statusBarController.statusItem.button {
            popover.show(from: button)
        }
    }
    
    func quickActionPanelDidCancel(_ panel: FloatingQuickActionPanel) {
    }
}
