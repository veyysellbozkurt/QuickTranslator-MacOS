//
//  StatusBarController.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 28.08.2025.
//

import AppKit

final class StatusBarController {
    
    let statusItem: NSStatusItem
    private let popover: MainPopover
    
    init(popover: MainPopover) {
        self.popover = popover
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            let buttonImage = NSImage(resource: .language)
            buttonImage.size = NSSize(width: 18, height: 18)
            buttonImage.isTemplate = false
            button.image = buttonImage
            button.action = #selector(buttonClicked(_:))
            button.target = self
        }
    }
    
    @objc private func buttonClicked(_ sender: AnyObject?) {
        guard let button = statusItem.button else { return }
        popover.toggle(from: button)
    }
}
