//
//  SettingsView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 17.09.2025.
//

import SwiftUI

struct SettingsContainerView: View {
    let windowManager: SettingsWindowManager
    @ObservedObject var selection: Coordinator
    
    class Coordinator: NSObject, ObservableObject {
        @Published var index: Int = 0
        weak var manager: SettingsWindowManager?
        
        init(manager: SettingsWindowManager?) {
            self.manager = manager
        }
        
        @objc func selectGeneral() { index = 0 }
        @objc func selectTranslation() { index = 1 }
        @objc func selectShortcuts() { index = 2 }
        @objc func selectAbout() { index = 3 }
    }
    
    func contentView(selection: Coordinator) -> some View {
        Group {
            switch selection.index {
                case 0: GeneralSettingsView()
                case 1: TranslationSettingsView()
                case 2: QuickActionSettingsView()
                case 3: GeneralSettingsView()
                case 4: AboutSettingsView(windowManager: windowManager)
                default: GeneralSettingsView()
            }
        }
    }
    
    var body: some View {
        let tabs: [TabItem] = [
            .init(label: "General", systemImageName: "gear"),
            .init(label: "Translation", systemImageName: "character.bubble.fill"),
            .init(label: "Quick Action", systemImageName: "lasso.badge.sparkles"),
            .init(label: "Guide", systemImageName: "lightbulb.min.fill"),
            .init(label: "About", systemImageName: "info.circle.fill"),
        ]
        
        VStack(spacing: 0) {
            CustomTabBar(tabs: tabs, selectedIndex: $selection.index)
                .padding(.bottom, 10)
                .padding(.horizontal, 50)
            Divider()
            contentView(selection: selection)
                .padding()
                .background(GeometryReader { _ in Color.clear })
        }
        .padding()
    }
}
