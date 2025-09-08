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
    
    @State private var showToast = false
    @State private var showLanguagePicker = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            languageSelector
            textView
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .toast(isPresented: $showToast, message: "Copied to Clipboard ✅")
    }
    
    // MARK: - Language Selector
    private var languageSelector: some View {
        Button {
            showLanguagePicker.toggle()
        } label: {
            HStack {
                Text(language.title)
                    .font(.body)
                Spacer()
                Image(systemName: SFIcons.chevronDown)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity)
            .frame(height: 28)
            .background(Color.secondary.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(.horizontal, 2)
        .buttonStyle(BounceButtonStyle())
        .popover(isPresented: $showLanguagePicker) {
            languagePickerPopover
        }
    }
    
    private var languagePickerPopover: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Language.allCases, id: \.self) { lang in
                    Button {
                        language = lang
                        showLanguagePicker = false
                    } label: {
                        Text(lang.title)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    Divider()
                }
            }
        }
        .frame(width: 200, height: 250)
    }
    
    // MARK: - Text View + Copy Button
    private var textView: some View {
        PaddedTextViewRepresentable(
            text: $text,
            onEnterKeyPress: onEnterKeyPress,
            placeholder: placeholder ?? ""
        )
        .scrollContentBackground(.hidden)
        .background(.clear)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.top, 0)
        .overlay(alignment: .bottomTrailing) {
            copyButton
        }
    }
    
    private var copyButton: some View {
        Button {
            copyTextToClipboard()
        } label: {
            Image(systemName: SFIcons.copy)
                .resizable()
                .frame(width: 16, height: 18)
                .padding(8)
                .foregroundStyle(text.isEmpty ? Color.secondary : Color.app)
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
