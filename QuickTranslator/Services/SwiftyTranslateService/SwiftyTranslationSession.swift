//
//  SwiftyTranslationSession.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 2.09.2025.
//

import SwiftUI
import Foundation

// MARK: - Translation Session
public class SwiftyTranslationSession: ObservableObject {
    
    public struct Configuration {
        let source: Language
        let target: Language
        
        public init(source: Language, target: Language) {
            self.source = source
            self.target = target
        }
        
        public func invalidate() {
            // Configuration invalidation logic if needed
        }
    }
    
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
    
    private let configuration: Configuration
    
    init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    @MainActor
    public func translate(_ text: String) async throws -> TranslationResponse {
        let translation = try await SwiftyTranslate.translate(
            text: text,
            from: configuration.source.identifier,
            to: configuration.target.identifier
        )
        return TranslationResponse(targetText: translation.translated)
    }
}

// MARK: - View Extension
extension View {
    public func swiftyTranslationTask(
        _ configuration: SwiftyTranslationSession.Configuration?,
        action: @escaping (SwiftyTranslationSession) async -> Void
    ) -> some View {
        self.modifier(SwiftyTranslationTaskModifier(configuration: configuration, action: action))
    }
}

// MARK: - Task Modifier
struct SwiftyTranslationTaskModifier: ViewModifier {
    let configuration: SwiftyTranslationSession.Configuration?
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
        guard let config = configuration else { return "" }
        return "\(config.source.identifier)-\(config.target.identifier)"
    }
}
