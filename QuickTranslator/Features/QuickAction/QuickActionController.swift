//
//  QuickActionController.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 27.08.2025.
//

import AppKit

final class QuickActionController: FloatingIconWindowDelegate {
    
    private let clipboard = ClipboardMonitor()
    private let floating = QuickActionPopup()
    private let viewModel: TranslateViewModel
    private let popover: MainPopover
    private var pendingText: String?
    
    init(viewModel: TranslateViewModel, popover: MainPopover) {
        self.viewModel = viewModel
        self.popover = popover
        floating.actionDelegate = self
    }
    
    func start() {
        clipboard.onCopy = { [weak self] text in
            guard let self else { return }
            self.pendingText = text
            self.floating.showNearMouse()
        }
        clipboard.start(interval: 0.4)
    }
    
    func stop() {
        clipboard.stop()
    }
    
    // MARK: - FloatingIconWindowDelegate
    func floatingIconDidConfirmTranslate(_ window: QuickActionPopup) {
        if let text = pendingText {
            viewModel.inputText = text
            viewModel.triggerTranslation()
            viewModel.translatedText = ""
        }
        if let button = popover.statusBarButton {
            popover.toggle(from: button)
        }
    }
    
    func floatingIconDidCancel(_ window: QuickActionPopup) {
        // İstersen no-op
    }
}
