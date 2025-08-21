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
    func triggerTranslation() {
        guard configuration == nil, !inputText.isEmpty else {
            configuration?.invalidate()
            return
        }
        toggleTranslating(to: true)
        configuration = .init(source: .init(identifier: "tr"), target: .init(identifier: "en"))
    }
    
    func toggleTranslating(to newValue: Bool) {
        withAnimation {
            isTranslating = newValue
        }
    }
}
