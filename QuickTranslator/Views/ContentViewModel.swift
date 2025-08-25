//
//  ContentViewModel.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 21.08.2025.
//

import SwiftUI
import Translation

final class ContentViewModel: ObservableObject {
    
    @Published var configuration: TranslationSession.Configuration?
    @Published var sourceLanguage: Language = .turkish
    @Published var targetLanguage: Language = .english
    
    @Published var inputText: String = ""
    @Published var translatedText: String = ""
    
    @Published var isTranslating: Bool = false
    @Published var errorMessage: String?
    
    init() {
        // TODO: source, target language set et UserDefaults tan
    }
}

extension ContentViewModel {
    @MainActor
    func makeTranslation(session: TranslationSession) async {
        guard !inputText.isEmpty else { return }
        isTranslating = true
        errorMessage = nil
        
        do {
            let response = try await session.translate(inputText)
            translatedText = response.targetText
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isTranslating = false
    }
    
    func triggerTranslation() {
        guard configuration == nil, !inputText.isEmpty else {
            configuration?.invalidate()
            return
        }
        updateConfiguration()
    }
    
    func swapInputs() {
        let tempLang = sourceLanguage
        sourceLanguage = targetLanguage
        targetLanguage = tempLang
        
        let tempText = inputText
        inputText = translatedText
        translatedText = tempText
        
        updateConfiguration()
    }
}

// MARK: - Helper Methods
private extension ContentViewModel {
    func updateConfiguration() {
        configuration = .init(source: .init(identifier: sourceLanguage.code),
                              target: .init(identifier: targetLanguage.code))
    }
}
