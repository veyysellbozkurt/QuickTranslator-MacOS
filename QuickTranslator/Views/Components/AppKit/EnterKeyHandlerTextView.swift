//
//  EnterKeyHandlerTextView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 19.08.2025.
//

import SwiftUI
import AppKit

final class EnterKeyHandlerTextView: NSTextView {
    private let enterKeyCode = 36
    var onEnterKeyPress: (() -> Void)?
    
    override func keyDown(with event: NSEvent) {
        if event.keyCode == enterKeyCode {
            if event.modifierFlags.contains(.shift) {
                insertNewline(nil)
            } else {
                onEnterKeyPress?()
            }
        } else {
            super.keyDown(with: event)
        }
    }
}
