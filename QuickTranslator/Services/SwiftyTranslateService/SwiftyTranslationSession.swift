//
//  SwiftyTranslationSession.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 2.09.2025.
//

import SwiftUI
import Foundation
import Translation

// MARK: - Translation Session
public class SwiftyTranslationSession: ObservableObject {
    
    public struct Language {
        let identifier: String
        
        public init(identifier: String) {
            self.identifier = identifier
        }
    }
    
    public struct TranslationResponse {
        public let targetText: String
        
        init(targetText: String) {
            self.targetText = targetText
        }
    }
    
    private let configuration: TranslationSession.Configuration
    
    init(configuration: TranslationSession.Configuration) {
        self.configuration = configuration
    }
    
    @MainActor
    public func translate(_ text: String) async throws -> TranslationResponse {
        let translation = try await SwiftyTranslate.translate(
            text: text,
            from: configuration.source?.minimalIdentifier ?? "en",
            to: configuration.target?.minimalIdentifier ?? "es"
        )
        return TranslationResponse(targetText: translation.translated)
    }
}

// MARK: - View Extension
extension View {
    public func swiftyTranslationTask(
        _ configuration: TranslationSession.Configuration?,
        action: @escaping (SwiftyTranslationSession) async -> Void
    ) -> some View {
        self.modifier(SwiftyTranslationTaskModifier(configuration: configuration, action: action))
    }
}

// MARK: - Task Modifier
struct SwiftyTranslationTaskModifier: ViewModifier {
    let configuration: TranslationSession.Configuration?
    let action: (SwiftyTranslationSession) async -> Void
    
    func body(content: Content) -> some View {
        content
            .task(id: configurationID) {
                guard let configuration = configuration else { return }
                let session = SwiftyTranslationSession(configuration: configuration)
                await action(session)
            }
    }
    
    private var configurationID: String {
        guard let config = configuration,
              let sourceLanguageCode = config.source?.minimalIdentifier,
              let targetLanguageCode = config.target?.minimalIdentifier else { return "" }
        return "\(sourceLanguageCode)-\(targetLanguageCode)"
    }
}
