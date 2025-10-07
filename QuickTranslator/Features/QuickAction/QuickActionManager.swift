//
//  QuickActionManager.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 27.08.2025.
//

import AppKit
import Carbon.HIToolbox

enum QuickActionType: String, Codable {
    case floatingIconPopover
    case directPopover
}

final class QuickActionManager {
    
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
            
            if FeatureManager.shared.quickActionType == .floatingIconPopover {
                floatingPanel.showNearMouse()
            } else {
                quickActionPanelDidConfirm()
            }
        }
        cmdMonitor.start()
    }
}

// MARK: - Floating Quick Action Panel Delegate
extension QuickActionManager: FloatingQuickActionPanelDelegate {
    func quickActionPanelDidConfirm() {
        if let text = copiedText {
            viewModel.translatedText = ""
            viewModel.inputText = text
            viewModel.triggerTranslation()
        }
        if let button = DIContainer.shared.statusBarController.statusItem.button {
            DIContainer.shared.mainPopover.show(from: button)
        }
    }
    
    func quickActionPanelDidCancel() {
    }
}

private extension QuickActionManager {
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
