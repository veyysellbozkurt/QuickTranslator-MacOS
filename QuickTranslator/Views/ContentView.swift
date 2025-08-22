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
    
    init(viewModel: ContentViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Add your text below:")
                .foregroundStyle(.secondary)
                .padding(6)
            
            PaddedTextViewRepresentable(
                text: $viewModel.inputText,
                onEnterKeyPress: {
                    viewModel.triggerTranslation()
                }
            )
            .font(.headline)
            .scrollContentBackground(.hidden)
            .background(.bar)
            .clipShape(.rect(cornerRadius: 12))
            .padding(4)
            
            Spacer()
            
            if viewModel.isTranslating {
                ProgressView("Translating...")
                    .padding()
            } else {
                Text("The translated text is:")
                    .foregroundStyle(.secondary)
                    .padding(6)
                
                PaddedTextViewRepresentable(text: $viewModel.translatedText)
                .font(.headline)
                .scrollContentBackground(.hidden)
                .background(.bar)
                .clipShape(.rect(cornerRadius: 12))
                .padding(4)
            }
            
            if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .padding(4)
            }
            
            translateButton
        }
        .padding(8)
        .animation(.default, value: viewModel.isTranslating)
        .translationTask(viewModel.configuration) { session in
            await viewModel.makeTranslation(session: session)
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
