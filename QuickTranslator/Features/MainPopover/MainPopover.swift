//
//  MainPopover.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 28.08.2025.
//

import SwiftUI
import AppKit
import Combine

final class MainPopover {
    
    private let popover: NSPopover
    private let viewModel: TranslateViewModel
    private var cancellables = Set<AnyCancellable>()
        
    private var minHeight: CGFloat
    private var maxHeight: CGFloat
    private var baseWidth: CGFloat
    
    init(viewModel: TranslateViewModel) {
        self.viewModel = viewModel
        let layout = FeatureManager.shared.inputLayout
        self.minHeight = layout.minHeight
        self.maxHeight = layout.maxHeight
        self.baseWidth = layout.baseWidth
        
        popover = NSPopover()
        popover.contentSize = NSSize(width: baseWidth, height: minHeight)
        popover.behavior = .transient
        
        let rootView = makeRootView(viewModel: viewModel).background(.appWindowBackground)
        popover.contentViewController = NSHostingController(rootView: rootView)
        
        setupDynamicHeightObserver()
        setupLayoutObserver()
    }
    
    @objc
    func show(from button: NSStatusBarButton) {
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        popover.contentViewController?.view.window?.becomeKey()
        DIContainer.shared.themeManager.applyCurrentFeatureTheme()
        Task { @MainActor in
            await SubscriptionManager.shared.checkSubscriptionStatus()
        }
    }
}

private extension MainPopover {
    func makeRootView(viewModel: TranslateViewModel) -> some View {
        VStack {
            TranslateView(viewModel: viewModel)
                .padding(.horizontal, 6)
                .padding(.top, 6)
            PopoverControls(popover: popover)
        }
        .background(.ultraThinMaterial)
    }
    
    func setupDynamicHeightObserver() {
        viewModel.$inputText
            .combineLatest(viewModel.$translatedText)
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .sink { [weak self] sourceText, translatedText in
                self?.updatePopoverHeight(sourceText: sourceText, translatedText: translatedText)
            }
            .store(in: &cancellables)
    }
    
    func setupLayoutObserver() {
        FeatureManager.shared.$inputLayout
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newLayout in
                self?.updateBaseMetrics(from: newLayout)
                self?.updateSize()
            }
            .store(in: &cancellables)
    }
    
    func updateBaseMetrics(from layout: InputLayout) {
        self.minHeight = layout.minHeight
        self.maxHeight = layout.maxHeight
        self.baseWidth = layout.baseWidth
    }
    
    func updateSize() {
        let sourceText = viewModel.inputText
        let translatedText = viewModel.translatedText
        updatePopoverHeight(sourceText: sourceText, translatedText: translatedText)
    }
    
    func updatePopoverHeight(sourceText: String, translatedText: String) {
        if sourceText.isEmpty && translatedText.isEmpty {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.3
                context.allowsImplicitAnimation = true
                popover.contentSize = NSSize(width: baseWidth, height: minHeight)
            }
            return
        }
        
        let calculatedHeight = calculateRequiredHeight(sourceText: sourceText, translatedText: translatedText)
        let newHeight = max(minHeight + 40, min(maxHeight, calculatedHeight))
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.2
            context.allowsImplicitAnimation = true
            popover.contentSize = NSSize(width: baseWidth, height: newHeight)
        }
    }
    
    func calculateRequiredHeight(sourceText: String, translatedText: String) -> CGFloat {
        let baseHeight: CGFloat = 10
        let lineHeight: CGFloat = 20
        let maxCharsPerLine: CGFloat = 50
                
        let sourceLines = max(1, ceil(CGFloat(sourceText.count) / maxCharsPerLine))
        let sourceHeight = sourceLines * lineHeight + 40
                
        let translatedLines = max(1, ceil(CGFloat(translatedText.count) / maxCharsPerLine))
        let translatedHeight = translatedLines * lineHeight + 40
        
        return baseHeight + sourceHeight + translatedHeight
    }
}
