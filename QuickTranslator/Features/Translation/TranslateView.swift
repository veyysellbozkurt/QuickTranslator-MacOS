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
    @ObservedObject private var featureManager = FeatureManager.shared
    
    init(viewModel: TranslateViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            ExchangeLanguageView(sourceLanguage: $viewModel.sourceLanguage,
                                 targetLanguage: $viewModel.targetLanguage) {
                viewModel.swapInputs()
            }
                                 .padding(.horizontal, 6)
            
            Group {
                if featureManager.inputLayout == .horizontal {
                    HStack(spacing: 8) {
                        inputsSection
                    }
                } else {
                    VStack(spacing: 8) {
                        inputsSection
                    }
                }
            }
        }
        .animation(.bouncy, value: viewModel.isTranslating)
        .animation(.snappy, value: featureManager.inputLayout)
        .translationTask(viewModel.configuration) { appleSession in
            guard let config = viewModel.configuration else { return }
            
            let translator = UnifiedTranslatorFactory.makeTranslator(
                configuration: config,
                appleSession: appleSession
            )
            await viewModel.makeTranslation(using: translator)
        }
    }
    
    // MARK: - Inputs
    @ViewBuilder
    private var inputsSection: some View {
        InputView(text: $viewModel.inputText,
                  language: $viewModel.sourceLanguage,
                  placeholder: Constants.Strings.inputPlaceholder) {
            viewModel.triggerTranslation()
        }
        
        ZStack {
            InputView(text: $viewModel.translatedText,
                      language: $viewModel.targetLanguage,
                      placeholder: Constants.Strings.outputPlaceholder,
                      isOutput: true,
                      isEditable: false)
            .opacity(viewModel.isTranslating ? 0.2 : 1)
            
            if viewModel.isTranslating {
                ProgressView(Constants.Strings.translating)
                    .progressViewStyle(.circular)
                    .foregroundStyle(.textPrimary)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    TranslateView(viewModel: TranslateViewModel())
        .frame(width: 400, height: 400)
}
