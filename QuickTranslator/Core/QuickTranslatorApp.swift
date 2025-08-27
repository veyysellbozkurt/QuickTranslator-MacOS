//
//  QuickTranslatorApp.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 18.08.2025.
//

import SwiftUI
import SwiftData

@main
struct QuickTranslatorApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var isPinned: Bool = false

    var body: some Scene {
            Settings {}
    }
}
