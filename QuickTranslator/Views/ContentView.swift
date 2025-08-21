//
//  ContentView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 18.08.2025.
//

import SwiftUI
import Translation

struct ContentView: View {
    @State private var textInput: String = ""
    @State private var translatedText: String = ""
    @State private var configuration: TranslationSession.Configuration?
    @State private var isTranslating: Bool = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Add your text below:")
                .foregroundStyle(.secondary)
                .padding(6)
            
            PaddedTextViewRepresentable(
                text: $textInput,
                onEnterKeyPress: {
                    triggerTranslation()
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
            
            Button(action: {
                triggerTranslation()
            }, label: {
                Label("Translate", systemImage: "square.on.square")
                    .bold()
                    .foregroundStyle(.blue)
            })
            .keyboardShortcut(
                .init("t"),
                modifiers: [.control])
            .buttonStyle(.plain)
            .padding(.top, 8)
        }
        .padding(8)
        .translationTask(configuration) { session in
            guard !textInput.isEmpty else { return }
            toggleTranslating(to: true)
            errorMessage = nil
            do {
                let response = try await session.translate(textInput)
                translatedText = response.targetText
            } catch {
                errorMessage = error.localizedDescription
            }
            toggleTranslating(to: false)
        }
    }
    
    private func triggerTranslation() {
        guard configuration == nil, !textInput.isEmpty else {
            configuration?.invalidate()
            return
        }
        toggleTranslating(to: true)
        configuration = .init(source: .init(identifier: "tr"), target: .init(identifier: "en"))
    }
    
    private func toggleTranslating(to newValue: Bool) {
        withAnimation {
            isTranslating = newValue
        }
    }
}

#Preview {
    ContentView()
        .frame(width: 400, height: 400)
}
