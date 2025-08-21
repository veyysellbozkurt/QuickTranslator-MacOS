//
//  ContentView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 18.08.2025.
//

import SwiftUI
import Translation

struct ContentView: View {
    
    @StateObject private var viewModel: ContentViewModel
    @State private var inputText: String = ""
    @State private var translatedText: String = ""
    @State private var configuration: TranslationSession.Configuration?
    @State private var isTranslating: Bool = false
    @State private var errorMessage: String?
    
    init(viewModel: ContentViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Add your text below:")
                .foregroundStyle(.secondary)
                .padding(6)
            
            PaddedTextViewRepresentable(
                text: $inputText,
                onEnterKeyPress: {
                    viewModel.triggerTranslation()
                })
            .font(.headline)
            .scrollContentBackground(.hidden)
            .background(.bar)
            .clipShape(.rect(cornerRadius: 12))
            .padding(4)
            
            Spacer()
            
            if isTranslating {
                ProgressView("Translating...")
                    .padding()
            } else {
                Text("The translated text is:")
                    .foregroundStyle(.secondary)
                    .padding(6)
                
                PaddedTextViewRepresentable(text: $translatedText)
                    .font(.headline)
                    .scrollContentBackground(.hidden)
                    .background(.bar)
                    .clipShape(.rect(cornerRadius: 12))
                    .padding(4)
            }
            
            if let error = errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .padding(4)
            }
            
            translateButton
        }
        .padding(8)
        .translationTask(configuration) { session in
            guard !inputText.isEmpty else { return }
            viewModel.toggleTranslating(to: true)
            errorMessage = nil
            do {
                let response = try await session.translate(inputText)
                translatedText = response.targetText
            } catch {
                errorMessage = error.localizedDescription
            }
            viewModel.toggleTranslating(to: false)
        }
    }
}
 
// MARK: - UI Elements
private extension ContentView {
    var translateButton: some View {
        Button {
            viewModel.triggerTranslation()
        } label: {
            Label("Translate", systemImage: "square.on.square")
                .bold()
                .foregroundStyle(.blue)
        }
        .keyboardShortcut(.init("t"), modifiers: [.control])
        .buttonStyle(.plain)
        .padding(.top, 8)
    }
}

// MARK: - Preview
#Preview {
    ContentView(viewModel: ContentViewModel())
        .frame(width: 400, height: 400)
}
