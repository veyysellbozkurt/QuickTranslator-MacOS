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
//    @MainActor
//    func makeTranslation(session: TranslationSession) async {
//        guard !inputText.isEmpty else { return }
//        
//        isTranslating = true
//        errorMessage = nil
//        defer { isTranslating = false }
//        
//        do {
//            let response = try await session.translate(inputText)
//            translatedText = response.targetText
//        } catch {
//            errorMessage = error.localizedDescription
//        }
//        
//        do {
//            let trans = try await SwiftyTranslate.translate(text: inputText, from: sourceLanguage.code, to: targetLanguage.code)
//#if DEBUG
//            print("\nVEYSEL <<<< gelgegl  in \(#function)-> ", trans.translated)
//#endif
//        } catch {
//        }
//    }
    
    @MainActor
    func makeTrans(session: SwiftyTranslationSession) async {
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
        
        do {
            let trans = try await SwiftyTranslate.translate(text: inputText, from: sourceLanguage.code, to: targetLanguage.code)
#if DEBUG
            print("\nVEYSEL <<<< gelgegl  in \(#function)-> ", trans.translated)
#endif
        } catch {
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
