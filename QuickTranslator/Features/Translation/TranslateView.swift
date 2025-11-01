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
    @ObservedObject private var subscriptionManager = SubscriptionManager.shared

    @State private var shakeOffset: CGFloat = 0

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
            guard let config = viewModel.configuration else { return }
            let translator = UnifiedTranslatorFactory.makeTranslator(
                configuration: config,
                appleSession: appleSession
            )
            await viewModel.makeTranslation(using: translator)
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
            if SubscriptionManager.shared.isSubscribed {
                viewModel.triggerTranslation()
            } else {
                shakeDailyLimit()
            }
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
            .opacity(viewModel.isTranslating ? 0.2 : 1)
            
            if viewModel.isTranslating {
                ProgressView(Constants.Strings.translating)
                    .progressViewStyle(.circular)
                    .foregroundStyle(.textPrimary)
            }
        }
        .subscriptionStyle(subscriptionManager.isSubscribed)
        .overlay(
            Group {
                if !subscriptionManager.isSubscribed {
                    DailyLimitReachedView()
                        .offset(x: shakeOffset)
                }
            }
        )
    }
}

// MARK: - Shake Animasyonu
private extension TranslateView {
    func shakeDailyLimit() {
        let values: [CGFloat] = [6, -6, 4, -4, 2, -2, 0]
        for (index, value) in values.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                withAnimation(.linear(duration: 0.05)) {
                    shakeOffset = value
                }
            }
        }
    }
}

// MARK: - Helpers
private extension View {
    /// Apply subscription-based opacity & hit testing
    func subscriptionStyle(_ isSubscribed: Bool) -> some View {
        self
            .opacity(isSubscribed ? 1 : 0.4)
            .allowsHitTesting(isSubscribed)
    }
}
