//
//  FloatingQuickActionPanelController.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 27.08.2025.
//

import AppKit

final class FloatingQuickActionManager {
    
    private let clipboardMonitor = ClipboardMonitor()
    private let floatingPanel = FloatingQuickActionPanel()
    private let viewModel: TranslateViewModel
    private let popover: MainPopover
    private var copiedText: String?
    
    init(viewModel: TranslateViewModel, popover: MainPopover) {
        self.viewModel = viewModel
        self.popover = popover
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
    func floatingTranslateIconDidConfirmTranslate(_ popup: FloatingQuickActionPanel) {
        if let text = copiedText {
            viewModel.inputText = text
            viewModel.triggerTranslation()
            viewModel.translatedText = ""
        }
        if let button = popover.statusBarButton {
            popover.toggle(from: button)
        }
    }
    
    func floatingTranslateIconDidCancel(_ popup: FloatingQuickActionPanel) {
    }
}
