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
    let statusBarController: StatusBarController
    lazy var quickActionController: FloatingQuickActionManager = {
        FloatingQuickActionManager(viewModel: viewModel, popover: mainPopover)
    }()
    
    init() {
        mainPopover = MainPopover(viewModel: viewModel)
        statusBarController = StatusBarController(popover: mainPopover)        
    }
}
