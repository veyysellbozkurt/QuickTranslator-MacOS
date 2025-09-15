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
    
    private let minHeight: CGFloat = 350
    private let maxHeight: CGFloat = 650
    private let baseWidth: CGFloat = 350
    
    init(viewModel: TranslateViewModel) {
        self.viewModel = viewModel
        popover = NSPopover()
        popover.contentSize = NSSize(width: baseWidth, height: minHeight)
        popover.behavior = .transient
        
        let rootView = makeRootView(viewModel: viewModel)
        popover.contentViewController = NSHostingController(rootView: rootView)
        
        setupDynamicHeightObserver()
    }
    
    @objc
    func show(from button: NSStatusBarButton) {
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        popover.contentViewController?.view.window?.becomeKey()
    }
}

private extension MainPopover {
    func makeRootView(viewModel: TranslateViewModel) -> some View {
        VStack {
            TranslateView(viewModel: viewModel)
            PopoverControls(popover: popover)
        }
        .background(Color.app.opacity(0.15))
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
        let baseHeight: CGFloat = 200
        let lineHeight: CGFloat = 20
        let maxCharsPerLine: CGFloat = 50
                
        let sourceLines = max(1, ceil(CGFloat(sourceText.count) / maxCharsPerLine))
        let sourceHeight = sourceLines * lineHeight + 40
                
        let translatedLines = max(1, ceil(CGFloat(translatedText.count) / maxCharsPerLine))
        let translatedHeight = translatedLines * lineHeight + 40
        
        return baseHeight + sourceHeight + translatedHeight
    }
}
