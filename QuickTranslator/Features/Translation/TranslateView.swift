//
//  TranslateView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 18.08.2025.
//

import SwiftUI
import Translation

struct TranslateView: View {
    
    @StateObject private var viewModel: TranslateViewModel
    
    init(viewModel: TranslateViewModel) {
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
            
            swapButton
            .padding(.vertical, 4)
            
            if viewModel.isTranslating {
                ZStack {
                    InputView(
                        text: $viewModel.translatedText,
                        language: $viewModel.targetLanguage
                    ).opacity(0.2)
                                                                
                    ProgressView(Constants.Strings.translating)
                        .progressViewStyle(.circular)
                        .foregroundStyle(Color.white)
                }
            } else {
                InputView(
                    text: $viewModel.translatedText,
                    language: $viewModel.targetLanguage
                )
            }
//            translateButton
//                .padding(.horizontal, 3)
        }
        .padding(12)
        .animation(.bouncy, value: viewModel.isTranslating)
        .translationTask(viewModel.configuration) { session in
            await viewModel.makeTranslation(session: session)
        }
    }
}

// MARK: - UI Elements
private extension TranslateView {
    var translateButton: some View {
        Button {
            viewModel.triggerTranslation()
        } label: {
            Text(Constants.Strings.translateButton)
                .font(.title3)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: 40)
        .frame(maxWidth: .infinity)
        .background(Color(nsColor: .app))
        .clipShape(.buttonBorder)
        .keyboardShortcut(.init("t"), modifiers: [.control])
        .buttonStyle(BounceButtonStyle())
    }
    
    var swapButton: some View {
        Button {
            viewModel.swapInputs()
        } label: {
            Image(.swap)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.app)
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
    TranslateView(viewModel: TranslateViewModel())
        .frame(width: 400, height: 400)
}
