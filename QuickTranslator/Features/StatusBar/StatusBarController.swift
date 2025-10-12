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
            let buttonImage = NSImage(resource: .translation3)
            buttonImage.size = NSSize(width: 21, height: 21)
            buttonImage.isTemplate = false
            button.image = buttonImage
            button.action = #selector(buttonClicked(_:))
            button.target = self
        }
    }
    
    @objc private func buttonClicked(_ sender: AnyObject?) {
        guard let button = statusItem.button else { return }
        // Seçimi zorla .apple yapma — kullanıcı tercihini koru
        DIContainer.shared.mainPopover.show(from: button)
    }
}
