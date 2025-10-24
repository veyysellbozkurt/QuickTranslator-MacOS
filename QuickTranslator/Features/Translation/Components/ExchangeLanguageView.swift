//
//  ExchangeLanguageView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 16.09.2025.
//

import SwiftUI

struct ExchangeLanguageView: View {
    
    @Binding var sourceLanguage: Language
    @Binding var targetLanguage: Language
    
    @State private var displaySourceLanguage: Language = .englishGB
    @State private var displaysTargetLanguage: Language = .englishUS
    
    @State private var showSourceLanguagePicker = false
    @State private var showTargetLanguagePicker = false
    
    @Namespace private var swapNamespace
    @State private var isSwapped = false
    
    var onChange: EmptyCallback?
    
    var body: some View {
        HStack(spacing: 8) {
            if !isSwapped {
                languageSelector(for: $displaySourceLanguage, isPresented: $showSourceLanguagePicker)
                    .matchedGeometryEffect(id: "source", in: swapNamespace)
                swapButton
                languageSelector(for: $displaysTargetLanguage, isPresented: $showTargetLanguagePicker)
                    .matchedGeometryEffect(id: "target", in: swapNamespace)
            } else {
                languageSelector(for: $displaysTargetLanguage, isPresented: $showTargetLanguagePicker)
                    .matchedGeometryEffect(id: "target", in: swapNamespace)
                swapButton
                languageSelector(for: $displaySourceLanguage, isPresented: $showSourceLanguagePicker)
                    .matchedGeometryEffect(id: "source", in: swapNamespace)
            }
        }
        .onAppear {
            displaySourceLanguage = sourceLanguage
            displaysTargetLanguage = targetLanguage
        }
    }
    
    private func languageSelector(for language: Binding<Language>, isPresented: Binding<Bool>) -> some View {
        Button {
            isPresented.wrappedValue.toggle()
        } label: {
            HStack {
                Text(language.wrappedValue.title)
                    .font(.appFont(.semibold, size: 13))
                Spacer()
                Image(systemName: "chevron.down")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 10)
            .frame(height: 32)
            .background(Color.secondary.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(BounceButtonStyle())
        .popover(isPresented: isPresented) {
            languagePickerPopover(for: language)
        }
    }
    
    private func languagePickerPopover(for language: Binding<Language>) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Language.availableLanguages, id: \.self) { lang in
                    let isSelected = lang == language.wrappedValue
                    Button {
                        language.wrappedValue = lang
                        showSourceLanguagePicker = false
                        showTargetLanguagePicker = false
                        sourceLanguage = displaySourceLanguage
                        targetLanguage = displaysTargetLanguage
                    } label: {
                        HStack {
                            Text(lang.title)
                                .font(.appFont(size: 13))
                                .foregroundColor(isSelected ? .white : .primary)
                            Spacer()
                            if isSelected {
                                Image(systemName: "checkmark")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(isSelected ? Color.secondary.opacity(0.1) : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .frame(width: 200, height: 250)
    }

    
    private var swapButton: some View {
        Button {
            performSwap()
        } label: {
            Image(.swap)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .foregroundStyle(Color.app)
                .padding(6)
                .background(Color.gray.opacity(0.1))
                .clipShape(Circle())
        }
        .rotationEffect(.degrees(90))
        .buttonStyle(BounceButtonStyle())
    }
}

private extension ExchangeLanguageView {
    func performSwap() {
        withAnimation(.snappy(extraBounce: 0.1)) {
            isSwapped.toggle()
        }
        onChange?()
    }
}
