//
//  MainPopover.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 28.08.2025.
//

import SwiftUI
import AppKit

final class MainPopover {
    
    private let popover: NSPopover
    
    init(viewModel: TranslateViewModel) {
        popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 550)
        popover.behavior = .transient
        let rootView = makeRootView(viewModel: viewModel)
        popover.contentViewController = NSHostingController(rootView: rootView)
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
        .background(Color.accentColor.opacity(0.15))
    }
}
