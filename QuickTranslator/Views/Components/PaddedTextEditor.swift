//
//  PaddedTextEditor.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 19.08.2025.
//

import SwiftUI
import AppKit

struct PaddedTextEditor: NSViewRepresentable {
    @Binding var text: String
    var insets: NSEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.borderType = .noBorder
        scrollView.drawsBackground = false

        let textView = NSTextView()
        textView.isRichText = false
        textView.isEditable = true
        textView.isSelectable = true
        textView.drawsBackground = false
        textView.font = NSFont.systemFont(ofSize: 14)
        textView.textContainerInset = CGSize(width: insets.left, height: insets.top)
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.autoresizingMask = [.width]

        // Text değişikliklerini SwiftUI binding’e aktar
        textView.delegate = context.coordinator

        scrollView.documentView = textView
        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        if let textView = nsView.documentView as? NSTextView {
            if textView.string != text {  // infinite loop önlemek için kontrol
                textView.string = text
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: PaddedTextEditor

        init(_ parent: PaddedTextEditor) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            if let textView = notification.object as? NSTextView {
                parent.text = textView.string
            }
        }
    }
}
