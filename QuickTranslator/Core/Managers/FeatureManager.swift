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
        
    private init() {
        inputLayout = userDefaults.value(InputLayout.self, forKey: .selectedInputLayout) ?? .horizontal
        _translationService = Published(
            initialValue: userDefaults.value(TranslationServiceType.self, forKey: .selectedTranslationService) ?? .google
        )
    }
    
    // MARK: - Input Layout
    @Published var inputLayout: InputLayout {
        didSet {
            userDefaults.set(encodable: inputLayout, forKey: .selectedInputLayout)
        }
    }
    
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
    @Published var translationService: TranslationServiceType {
        didSet {
            userDefaults.set(encodable: translationService, forKey: .selectedTranslationService)
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
    
    // MARK: - Double Key Interval
    var floatingIconVisibilityDuration: Double {
        get {
            userDefaults.double(forKey: .floatingIconVisibilityDuration)
        }
        set {
            userDefaults.set(newValue, forKey: .floatingIconVisibilityDuration)
        }
    }
    
    // MARK: - Menu Bar icon
    var menuBarIcon: MenuBarIconEnum {
        get {
            let savedValue = userDefaults.string(forKey: .menuBarIconName) ?? nil
            return MenuBarIconEnum(rawValue: savedValue ?? "") ?? MenuBarIconEnum.light
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: .menuBarIconName)
        }
    }
}
