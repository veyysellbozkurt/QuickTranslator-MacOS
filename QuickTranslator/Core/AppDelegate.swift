//
//  AppDelegate.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 18.08.2025.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var container: DIContainer!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        container = DIContainer()
        container.quickActionController.start()
    }
}
