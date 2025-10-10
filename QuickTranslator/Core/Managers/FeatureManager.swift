//
//  FeatureManager.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 5.09.2025.
//

import Foundation
import Translation

final class FeatureManager: ObservableObject {
    
    static let shared = FeatureManager()
    private let userDefaults = UserDefaults.standard
    
    private init() { }
    
    // MARK: - Quick Action
    var quickActionType: QuickActionType {
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
    
    // MARK: - Launch on Start
    var launchOnStart: Bool {
        get {
            userDefaults.bool(forKey: .launchOnStart)
        }
        set {
            userDefaults.set(newValue, forKey: .launchOnStart)
        }
    }
    
    // MARK: - Input Layout
    var inputLayout: InputLayout {
        get {
            userDefaults.value(InputLayout.self, forKey: .selectedInputLayout) ?? .horizontal
        }
        set {
            userDefaults.set(encodable: newValue, forKey: .selectedInputLayout)
        }
    }
    
    // MARK: - Double Key Interval
    var doubleKeyInterval: Double {
        get {
            userDefaults.double(forKey: .doubleKeyInterval)
        }
        set {
            userDefaults.set(newValue, forKey: .doubleKeyInterval)
        }
    }
}
