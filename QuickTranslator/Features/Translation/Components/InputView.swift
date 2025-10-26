//
//  InputView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 22.08.2025.
//

import SwiftUI

struct InputView: View {
    
    @Binding var text: String
    @Binding var language: Language
    var placeholder: String?
    var onEnterKeyPress: (() -> Void)? = nil
    var isOutput: Bool = false
    var isEditable: Bool = true
    
    @State private var showToast = false
    @State private var showLanguagePicker = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            textView
        }
        .toast(isPresented: $showToast, message: "Copied to Clipboard ✅")
    }
    
    // MARK: - Text View + Copy Button
    private var textView: some View {
        PaddedTextViewRepresentable(
            text: $text,
            onEnterKeyPress: onEnterKeyPress,
            placeholder: placeholder ?? "",
            isOutput: isOutput,
            isEditable: isEditable
        )
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(alignment: .bottomTrailing) {
            copyButton
        }
    }
    
    private var copyButton: some View {
        Button {
            copyTextToClipboard()
        } label: {
            Image(.copy)
                .resizable()
                .frame(width: 15, height: 16)
                .padding(4)
                .foregroundStyle(text.isEmpty ? .textPlaceholder : .app.opacity(0.8))
        }
        .buttonStyle(BounceButtonStyle())
        .padding(6)
        .disabled(text.isEmpty)
    }
    
    // MARK: - Actions
    private func copyTextToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
        pasteboard.setString(PasteboardMarker.value, forType: PasteboardMarker.type)
        withAnimation {
            showToast = true
        }
    }
}
