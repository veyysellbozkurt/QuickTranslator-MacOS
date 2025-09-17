//
//  DIContainer.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 28.08.2025.
//

final class DIContainer {
    
    static let shared = DIContainer()
    
    let viewModel = TranslateViewModel()
    
    let mainPopover: MainPopover
    let statusBarController = StatusBarController()
    let settingsWindowManager = SettingsWindowManager()
    lazy var quickActionManager: QuickActionManager = { QuickActionManager(viewModel: viewModel) }()
    
    init() {
        mainPopover = MainPopover(viewModel: viewModel)
    }
}
