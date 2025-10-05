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
    @State private var displayeTargetLanguage: Language = .englishUS
    
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
                languageSelector(for: $displayeTargetLanguage, isPresented: $showTargetLanguagePicker)
                    .matchedGeometryEffect(id: "target", in: swapNamespace)
            } else {
                languageSelector(for: $displayeTargetLanguage, isPresented: $showTargetLanguagePicker)
                    .matchedGeometryEffect(id: "target", in: swapNamespace)
                swapButton
                languageSelector(for: $displaySourceLanguage, isPresented: $showSourceLanguagePicker)
                    .matchedGeometryEffect(id: "source", in: swapNamespace)
            }
        }
        .onAppear {
            displaySourceLanguage = sourceLanguage
            displayeTargetLanguage = targetLanguage
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
                Image(systemName: "chevron.down")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity)
            .frame(height: 28)
            .background(Color.secondary.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 8))            
        }
        .buttonStyle(BounceButtonStyle())
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
                .background(.white)
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
