//
//  PaddedTextViewRepresentable.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 21.08.2025.
//

import SwiftUI
import AppKit

/// An `NSViewRepresentable` that wraps an `NSTextView` in a scrollable view with customizable padding.
/// Updates the bound SwiftUI `String` whenever the text changes.
struct PaddedTextViewRepresentable: NSViewRepresentable {
    @Binding var text: String
    var inset: CGSize = .init(width: 10, height: 10)
    var onEnterKeyPress: (() -> Void)? = nil
    var placeholder: String = ""
    var isOutput: Bool = false
    var isEditable: Bool = true
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeNSView(context: Context) -> NSScrollView {
        let textView = EnterKeyHandlerTextView()
        textView.string = text
        textView.placeholder = placeholder
        
        textView.isEditable = isEditable
        textView.isRichText = false
        textView.textContainerInset = inset
        textView.autoresizingMask = [.width]
        textView.delegate = context.coordinator
        
        textView.textColor = .textPrimary
        textView.font = .appFont(size: 13)
        
        textView.onEnterKeyPress = onEnterKeyPress
        
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.drawsBackground = true
        scrollView.backgroundColor = .hoverBackground
        scrollView.documentView = textView
        
        return scrollView
    }
    
    func updateNSView(_ nsView: NSScrollView, context: Context) {
        if let textView = nsView.documentView as? NSTextView,
           textView.string != text {
            textView.string = text
        }
    }
    
    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: PaddedTextViewRepresentable
        
        init(parent: PaddedTextViewRepresentable) {
            self.parent = parent
        }
        
        func textDidChange(_ notification: Notification) {
            if let textView = notification.object as? NSTextView {
                parent.text = textView.string
            }
        }
    }
}
