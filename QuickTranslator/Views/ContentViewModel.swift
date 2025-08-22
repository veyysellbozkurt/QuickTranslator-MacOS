//
//  ContentViewModel.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 21.08.2025.
//

import SwiftUI
import Translation

final class ContentViewModel: ObservableObject {
    
    @Published var inputText: String = ""
    @Published var translatedText: String = ""
    @Published var isTranslating: Bool = false
    @Published var errorMessage: String?
    @Published var configuration: TranslationSession.Configuration?
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
        configuration = .init(source: .init(identifier: "en"),
                              target: .init(identifier: "tr"))
    }
}
