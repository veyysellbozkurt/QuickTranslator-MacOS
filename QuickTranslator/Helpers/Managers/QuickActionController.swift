//
//  QuickActionController.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 27.08.2025.
//

import AppKit

final class QuickActionController: FloatingIconWindowDelegate {
    private let clipboard = ClipboardMonitor()
    private let floating = FloatingIconWindow()
    private weak var appDelegate: AppDelegate?
    private let viewModel: ContentViewModel
    private var pendingText: String?

    init(appDelegate: AppDelegate, viewModel: ContentViewModel) {
        self.appDelegate = appDelegate
        self.viewModel = viewModel
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
    func floatingIconDidConfirmTranslate(_ window: FloatingIconWindow) {
        guard let appDelegate else { return }
        if let text = pendingText {
            viewModel.inputText = text
            viewModel.triggerTranslation()
            viewModel.translatedText = ""
        }
        appDelegate.togglePopover(appDelegate.statusItem.button)
    }

    func floatingIconDidCancel(_ window: FloatingIconWindow) {
        // İstersen no-op
    }
}
