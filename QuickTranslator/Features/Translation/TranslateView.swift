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
            ExchangeLanguageView(sourceLanguage: $viewModel.sourceLanguage,
                                 targetLanguage: $viewModel.targetLanguage) {
                viewModel.swapInputs()
            }
            
            InputView(text: $viewModel.inputText,
                      language: $viewModel.sourceLanguage,
                      placeholder: Constants.Strings.inputPlaceholder) {
                viewModel.triggerTranslation()
            }
            
            ZStack {
                InputView(text: $viewModel.translatedText,
                          language: $viewModel.targetLanguage,
                          placeholder: Constants.Strings.outputPlaceholder)
                .opacity(viewModel.isTranslating ? 0.2 : 1)
                
                if viewModel.isTranslating {
                    ProgressView(Constants.Strings.translating)
                        .progressViewStyle(.circular)
                        .foregroundStyle(Color.white)
                }
            }
        }
        .padding([.horizontal, .top], 10)
        .animation(.bouncy, value: viewModel.isTranslating)
        .translationTask(viewModel.configuration) { session in
            await viewModel.makeTranslation(session: session)
        }
    }
}

// MARK: - Preview
#Preview {
    TranslateView(viewModel: TranslateViewModel())
        .frame(width: 400, height: 400)
}
