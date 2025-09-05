//
//  FloatingQuickActionPanelController.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 27.08.2025.
//

import AppKit
import Carbon.HIToolbox

final class FloatingQuickActionManager {
    
    private let cmdMonitor = DoubleKeyMonitor(doubleKey: .cmdC)
    private let floatingPanel: FloatingQuickActionPanel
    private let viewModel: TranslateViewModel
    private var copiedText: String?
    
    init(
        viewModel: TranslateViewModel,
        panel: FloatingQuickActionPanel = FloatingQuickActionPanel()
    ) {
        self.viewModel = viewModel
        self.floatingPanel = panel
        floatingPanel.actionDelegate = self
    }
    
    func start() {
        cmdMonitor.onDoublePress = {
            [weak self] in
            guard let self,
                  let text = NSPasteboard.general.string(forType: .string)?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
                
                if self.isCopiedFromApp(text) {
                    return
                }
                
                self.copiedText = text
            // TODO: Feature kontrolü yapılıp (icon ya da doğrudan translate çıkacak)
//            self.floatingPanel.showNearMouse()
                quickActionPanelDidConfirm(.init())
        }
        cmdMonitor.start()
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
            DIContainer.shared.mainPopover.show(from: button)
        }
    }
    
    func quickActionPanelDidCancel(_ panel: FloatingQuickActionPanel) {
    }
}

private extension FloatingQuickActionManager {
    func isCopiedFromApp(_ text: String) -> Bool {
        let pasteboard = NSPasteboard.general
        if pasteboard.string(forType: PasteboardMarker.type) == PasteboardMarker.value {
            pasteboard.clearContents()
            pasteboard.setString(text, forType: .string)
            return true
        }
        return false
    }
}
