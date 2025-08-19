//
//  ApplicationMenu.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 18.08.2025.
//

import Foundation
import SwiftUI

final class ApplicationMenu: NSObject {
    
    let menu = NSMenu()
    
    func createMenuItem() -> NSMenu {
        let contentView = ContentView()
        let topView = NSHostingView(rootView: contentView)
        topView.frame.size = CGSize(width: 250, height: 250)
        
        let customMenuItem = NSMenuItem()
        customMenuItem.view = topView
        menu.addItem(customMenuItem)
        menu.addItem(.separator())
        
        return menu
    }
    
    @objc func menuClicked() {
        print("Menu clicked")
    }
}

private extension ApplicationMenu {
    
}
