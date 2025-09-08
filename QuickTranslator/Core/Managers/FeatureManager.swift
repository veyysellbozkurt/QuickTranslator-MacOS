//
//  FeatureManager.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 5.09.2025.
//

import Foundation
import Translation

enum TranslationFeature: String, CaseIterable {
    case selectAndTranslate
    case copyAndTranslate
}

final class FeatureManager {
    
    static let shared = FeatureManager()
    private let userDefaults = UserDefaults.standard
    
    private init() { }
    
    // MARK: - Active Feature
    
    var activeFeature: TranslationFeature? {
        get {
            guard let rawValue = userDefaults.string(forKey: .quickActionTranslationType) else { return nil }
            return TranslationFeature(rawValue: rawValue)
        }
        set {
            if let feature = newValue {
                userDefaults.set(feature.rawValue, forKey: .quickActionTranslationType)
            } else {
                userDefaults.removeObject(forKey: .quickActionTranslationType)
            }
        }
    }
    
    // MARK: - Feature Management
    
    func enable(_ feature: TranslationFeature) {
        activeFeature = feature
    }
    
    func disable() {
        activeFeature = nil
    }
    
    func toggle(_ feature: TranslationFeature) {
        if activeFeature == feature {
            disable()
        } else {
            enable(feature)
        }
    }
    
    func isEnabled(_ feature: TranslationFeature) -> Bool {
        return activeFeature == feature
    }
}
