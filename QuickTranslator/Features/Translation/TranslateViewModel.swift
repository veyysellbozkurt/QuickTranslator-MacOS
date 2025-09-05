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
        
        translateViaWeb(text: inputText, from: "tr", to: "en") { translatedText in
#if DEBUG
            print("\nVEYSEL <<<< Translated:  in \(#function)-> ", translatedText ?? "-")
#endif
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



import Foundation

func translateViaWeb(text: String, from source: String = "tr", to target: String = "en", completion: @escaping (String?) -> Void) {
    let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    let urlStr = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=\(source)&tl=\(target)&dt=t&q=\(encodedText)"
    
    guard let url = URL(string: urlStr) else {
        completion(nil)
        return
    }

    let task = URLSession.shared.dataTask(with: url) { data, _, error in
        if let error = error {
            print("HTTP request failed: \(error)")
            completion(nil)
            return
        }
        guard let data = data else {
            completion(nil)
            return
        }

        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [Any]
            
            // json[0] array olmalı
            guard let sentences = json?[0] as? [[Any]] else {
                completion(nil)
                return
            }
            
            // Tüm segmentleri birleştir
            let translatedText = sentences.compactMap { segment -> String? in
                return segment.first as? String
            }.joined()
            
            completion(translatedText)
            
        } catch {
            print("JSON parse error: \(error)")
            completion(nil)
        }
    }

    task.resume()
}
