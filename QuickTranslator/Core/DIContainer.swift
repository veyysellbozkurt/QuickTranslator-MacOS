//
//  DIContainer.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 28.08.2025.
//

import AppKit

final class DIContainer {
    
    static let shared = DIContainer()
    
    let viewModel = TranslateViewModel()
    
    private(set) var mainPopover: MainPopover
    private(set) var statusBarController = StatusBarController()
    private(set) var settingsWindowManager = SettingsWindowManager()
    private(set) var themeManager = ThemeManager()
    private(set) var subscriptionManager = SubscriptionManager()
    lazy var quickActionManager: QuickActionManager = { QuickActionManager(viewModel: viewModel) }()
    
    private init() {
        self.mainPopover = MainPopover(viewModel: viewModel)
    }
}
