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
        VStack {

            InputView(
                text: $viewModel.inputText,
                language: $viewModel.sourceLanguage,
                placeholder: Constants.Strings.inputPlaceholder
            ) {
                viewModel.triggerTranslation()
            }
            .padding(.horizontal, 8)
                        
            swapButton
                .padding(.vertical, 6)
                       
            if viewModel.isTranslating {
                ProgressView("Translating...")
                    .padding()
            } else {
                InputView(
                    text: $viewModel.translatedText,
                    language: $viewModel.targetLanguage
                )
                .padding(.horizontal, 8)
            }
                        
            translateButton
                .padding(.top, 8)
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
            Text("Translate")
                .font(.title3)
                .foregroundStyle(.white)
        }
        .frame(width: 180, height: 40)
        .background(Color(nsColor: .app))
        .clipShape(.buttonBorder)
        .keyboardShortcut(.init("t"), modifiers: [.control])
        .buttonStyle(BounceButtonStyle())
        .shadow(color: Color(nsColor: .app.withAlphaComponent(0.4)), radius: 3)
    }
    
    var swapButton: some View {
        Button {
            viewModel.swapInputs()
        } label: {
            Image(.swap)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.blue)
                .padding(6)
                .background(.white)
                .clipShape(Circle())
        }
        .clipShape(Circle())
        .buttonStyle(BounceButtonStyle())
        .shadow(color: .white.opacity(0.4), radius: 3)
    }
}

// MARK: - Preview
#Preview {
    ContentView(viewModel: ContentViewModel())
        .frame(width: 400, height: 400)
}
