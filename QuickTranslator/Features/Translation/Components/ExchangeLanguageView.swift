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
    
    @State private var showSourceLanguagePicker = false
    @State private var showTargetLanguagePicker = false
    
    var onChange: EmptyCallback?
    
    var body: some View {
        HStack {
            languageSelector(for: $sourceLanguage, isPresented: $showSourceLanguagePicker)
            swapButton
            languageSelector(for: $targetLanguage, isPresented: $showTargetLanguagePicker)
        }
    }
    
    private func languageSelector(for language: Binding<Language>, isPresented: Binding<Bool>) -> some View {
        Button {
            isPresented.wrappedValue.toggle()
        } label: {
            HStack {
                Text(language.wrappedValue.title)
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
        .popover(isPresented: isPresented) {
            languagePickerPopover(for: language)
        }
    }
    
    private func languagePickerPopover(for language: Binding<Language>) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Language.allCases, id: \.self) { lang in
                    Button {
                        language.wrappedValue = lang
                        showSourceLanguagePicker = false
                        showTargetLanguagePicker = false
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
    
    var swapButton: some View {
        Button {
            onChange?()
        } label: {
            Image(.swap)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .foregroundStyle(Color.app)
                .padding(6)
                .background(.white)
                .clipShape(Circle())
        }
        .clipShape(Circle())
        .rotationEffect(.degrees(90))
        .buttonStyle(BounceButtonStyle())
    }
}
