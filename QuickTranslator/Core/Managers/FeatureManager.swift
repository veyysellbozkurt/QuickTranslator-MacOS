//
//  FeatureManager.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 5.09.2025.
//

import Foundation
import Translation

final class FeatureManager {
    
    static let shared = FeatureManager()
    private let userDefaults = UserDefaults.standard
    
    private init() { }
    
    // MARK: - Quick Action
    var quickActionType: QuickActionType? {
        get {
            userDefaults.value(QuickActionType.self, forKey: .selectedQuickActionType) ?? .directPopover
        }
        set {
            userDefaults.set(encodable: newValue, forKey: .selectedQuickActionType)
        }
    }
    
    // MARK: - Translation Service
    var translationService: TranslationServiceType {
        get {
            userDefaults.value(TranslationServiceType.self, forKey: .selectedTranslationService) ?? .google
        }
        set {
            userDefaults.set(encodable: newValue, forKey: .selectedTranslationService)
        }
    }
    
    // MARK: - Feature Management
    func enable(_ feature: QuickActionType) {
        quickActionType = feature
    }
    
    func disable() {
        quickActionType = nil
    }
    
    func toggle(_ feature: QuickActionType) {
        if quickActionType == feature {
            disable()
        } else {
            enable(feature)
        }
    }
    
    func isEnabled(_ feature: QuickActionType) -> Bool {
        return quickActionType == feature
    }
}
