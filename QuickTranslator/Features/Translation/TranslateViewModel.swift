//
//  TranslateViewModel.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 21.08.2025.
//

import SwiftUI
import Translation

final class TranslateViewModel: ObservableObject {
        
    @Published var configuration: TranslationSession.Configuration?
    @Published var sourceLanguage: Language = .englishUS { didSet { updateConfiguration() }}
    @Published var targetLanguage: Language = .spanishES { didSet { updateConfiguration() }}
    
    @Published var inputText: String = ""
    @Published var translatedText: String = ""
    
    @Published var isTranslating: Bool = false
    @Published var errorMessage: String?
    
    private var canTranslate: Bool {
        !inputText.isEmpty && !isTranslating
    }
    
    init() {
        guard let savedSource = Storage.string(forKey: .sourceLanguage),
              let savedTarget = Storage.string(forKey: .targetLanguage) else { return }
        
        sourceLanguage = Language(rawValue: savedSource) ?? .englishUS
        targetLanguage = Language(rawValue: savedTarget) ?? .spanishES
    }
}

extension TranslateViewModel {
    @MainActor
    func makeTranslation(using translator: TranslationService) async {
        guard !inputText.isEmpty else { return }
        isTranslating = true
        defer { isTranslating = false }

        do {
            translatedText = try await translator.translate(inputText)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func triggerTranslation() {
        guard configuration == nil, !inputText.isEmpty else {
            configuration?.invalidate()
            return
        }
        updateConfiguration()
    }
    
    func swapInputs() {
        swap(&sourceLanguage, &targetLanguage)
        inputText = translatedText
        
        updateConfiguration()
    }
}

// MARK: - Helper Methods
private extension TranslateViewModel {
    func updateConfiguration() {
        configuration = .init(source: .init(identifier: sourceLanguage.code),
                              target: .init(identifier: targetLanguage.code))
        Storage.set(sourceLanguage.rawValue, forKey: .sourceLanguage)
        Storage.set(targetLanguage.rawValue, forKey: .targetLanguage)
    }
}
