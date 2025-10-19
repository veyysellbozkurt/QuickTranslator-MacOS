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
    }
    
    func contentView(selection: Coordinator) -> some View {
        Group {
            switch selection.index {
                case 0: GeneralSettingsView()
                case 1: TranslationSettingsView()
                case 2: QuickActionSettingsView()
                case 3: AboutSettingsView()
                default: GeneralSettingsView()
            }
        }
        .background(
            GeometryReader { geo in
                Color.clear
                    .preference(key: ViewHeightKey.self, value: geo.size.height)
            }
        )
    }
    
    var body: some View {
        let tabs: [TabItem] = [
            .init(label: "General", systemImageName: "gear"),
            .init(label: "Translation", systemImageName: "character.bubble.fill"),
            .init(label: "Quick Action", systemImageName: "lasso.badge.sparkles"),
            .init(label: "About", systemImageName: "info.circle.fill"),
        ]
        
        VStack(spacing: 0) {
            CustomTabBar(tabs: tabs, selectedIndex: $selection.index)
                .padding(.bottom, 10)
                .padding(.horizontal, 50)
            Divider()
            contentView(selection: selection)
                .padding()
        }
        .padding()
        .onPreferenceChange(ViewHeightKey.self) { height in
            guard height > 0 else { return }
            windowManager.updateWindowHeight(to: height)
        }
    }
}

fileprivate struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
