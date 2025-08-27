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
    @Published var sourceLanguage: Language = .english { didSet { updateConfiguration() }}
    @Published var targetLanguage: Language = .spanish { didSet { updateConfiguration() }}
    
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
        
        sourceLanguage = Language(rawValue: savedSource) ?? .english
        targetLanguage = Language(rawValue: savedTarget) ?? .spanish
    }
}

extension ContentViewModel {
    @MainActor
    func makeTranslation(session: TranslationSession) async {
        guard !inputText.isEmpty else { return }
        
        isTranslating = true
        errorMessage = nil
        defer { isTranslating = false }
        
        do {
            let response = try await session.translate(inputText)
            translatedText = response.targetText
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
private extension ContentViewModel {
    func updateConfiguration() {
        configuration = .init(source: .init(identifier: sourceLanguage.code),
                              target: .init(identifier: targetLanguage.code))
        Storage.set(sourceLanguage.rawValue, forKey: .sourceLanguage)
        Storage.set(targetLanguage.rawValue, forKey: .targetLanguage)
    }
}
