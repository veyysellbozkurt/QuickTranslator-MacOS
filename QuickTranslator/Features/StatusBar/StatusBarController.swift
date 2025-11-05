//
//  StatusBarController.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 28.08.2025.
//

import AppKit

final class StatusBarController {
    
    let statusItem: NSStatusItem
    
    init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            let buttonImage = FeatureManager.shared.menuBarIcon.image
            buttonImage.size = NSSize(width: 21, height: 21)
            buttonImage.isTemplate = false
            button.image = buttonImage
            button.action = #selector(buttonClicked(_:))
            button.target = self
            
            openInitialWindow()
        }
    }
    
    @objc private func buttonClicked(_ sender: AnyObject?) {
        guard let button = statusItem.button else { return }
        DIContainer.shared.mainPopover.show(from: button)
    }
    
    private func openInitialWindow() {
        guard let button = statusItem.button else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            DIContainer.shared.mainPopover.show(from: button)
        }
    }
}
