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
    @ObservedObject private var dailyUsageManager = DailyUsageManager.shared
        
    init(viewModel: TranslateViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 6) {
            languageExchangeSection
                .padding(.horizontal, 6)
            
            if featureManager.inputLayout == .horizontal {
                HStack(spacing: 6) {
                    inputArea
                    outputArea
                }
            } else {
                VStack(spacing: 6) {
                    inputArea
                    outputArea
                }
            }
        }
        .animation(.bouncy, value: viewModel.isTranslating)
        .animation(.snappy, value: featureManager.inputLayout)
        .translationTask(viewModel.configuration) { appleSession in
            await viewModel.makeTranslation(using: appleSession)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                RatingService.shared.requestRatingIfNeeded()
            }
        }
    }
}

// MARK: - Sections
private extension TranslateView {
    var languageExchangeSection: some View {
        ExchangeLanguageView(
            sourceLanguage: $viewModel.sourceLanguage,
            targetLanguage: $viewModel.targetLanguage
        ) {
            viewModel.swapInputs()
        }
    }
    
    var inputArea: some View {
        InputView(
            text: $viewModel.inputText,
            language: $viewModel.sourceLanguage,
            placeholder: Constants.Strings.inputPlaceholder
        ) {
            viewModel.triggerTranslation()
        }
    }
    
    var outputArea: some View {
        ZStack {
            InputView(
                text: $viewModel.translatedText,
                language: $viewModel.targetLanguage,
                placeholder: Constants.Strings.outputPlaceholder,
                isOutput: true,
                isEditable: false
            )
            .opacity(viewModel.isTranslating ? 0 : 1)
            
            if viewModel.isTranslating {
                SkeletonShimmerView()
                    .transition(.opacity.combined(with: .blurReplace))
            }
        }
        .opacity(dailyUsageManager.isLimitReached ? 0.4 : 1)
        .overlay(
            Group {
                if dailyUsageManager.isLimitReached {
                    DailyLimitReachedView()
                        .offset(x: viewModel.shakeOffset)
                }
            }
        )
    }
}
