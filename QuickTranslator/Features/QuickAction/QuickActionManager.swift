//
//  QuickActionManager.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 27.08.2025.
//

import AppKit

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
        cmdMonitor.onDoublePress = { [weak self] in
            guard let self else { return }
            
            guard let text = self.getPureTextFromPasteboard(),
                              !self.isCopiedFromApp(text) else { return }
                                                
            self.copiedText = text
            
            if FeatureManager.shared.quickActionType == .floatingIconPopover {
                floatingPanel.showNearMouse(autoHideAfter: FeatureManager.shared.floatingIconVisibilityDuration)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.quickActionPanelDidConfirm()
                }
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
    
    func getPureTextFromPasteboard() -> String? {
        let pasteboard = NSPasteboard.general
        guard let types = pasteboard.types, types.contains(.string) else { return nil }
        
        let disallowed: Set<NSPasteboard.PasteboardType> = [.png, .sound, .fileURL, .tiff]
        guard disallowed.isDisjoint(with: Set(types)) else { return nil }
        
        guard let text = pasteboard.string(forType: .string)?
                .trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty else { return nil }
        
        return text
    }
}
