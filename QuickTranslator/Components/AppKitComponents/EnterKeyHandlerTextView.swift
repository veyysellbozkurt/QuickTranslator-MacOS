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
    var placeholder: String = "" { didSet { needsDisplay = true }}
    var placeholderColor: NSColor = .gray.withAlphaComponent(0.5)
    
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
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        if string.isEmpty {
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: placeholderColor,
                .font: NSFont.systemFont(ofSize: 13, weight: .medium)
            ]
            placeholder.draw(in: dirtyRect.insetBy(dx: 12, dy: 8), withAttributes: attributes)
        }
    }
}
