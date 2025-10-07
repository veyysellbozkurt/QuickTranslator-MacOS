//
//  TranslationFactory.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 2.09.2025.
//

import SwiftUI
import Foundation
import Translation

enum TranslationServiceType: String, Codable {
    case apple
    case google
}

protocol TranslationService {
    func translate(_ text: String) async throws -> String
}

final class AppleTranslationService: TranslationService {
    private let session: TranslationSession
    
    init(session: TranslationSession) {
        self.session = session
    }
    
    func translate(_ text: String) async throws -> String {
        let response = try await session.translate(text)
        return response.targetText
    }
}

final class GoogleTranslationService: TranslationService {
    private let from: String
    private let to: String
    
    init(from: String, to: String) {
        self.from = from
        self.to = to
    }
    
    func translate(_ text: String) async throws -> String {
        let result = try await SwiftyTranslate.translate(text: text, from: from, to: to)
        return result.translated
    }
}


final class UnifiedTranslatorFactory {
    
    static func makeTranslator(configuration: TranslationSession.Configuration,
                               appleSession: TranslationSession?) -> TranslationService {
        let source = configuration.source?.minimalIdentifier ?? "en"
        let target = configuration.target?.minimalIdentifier ?? "es"
        
        if let appleSession, FeatureManager.shared.translationService == .apple {
            return AppleTranslationService(session: appleSession)
        } else {
            return GoogleTranslationService(from: source, to: target)
        }
    }
}
