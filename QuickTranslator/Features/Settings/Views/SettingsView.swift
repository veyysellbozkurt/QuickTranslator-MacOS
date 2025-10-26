//
//  SettingsView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 17.09.2025.
//

import SwiftUI

struct SettingsContainerView: View {
    @State private var contentSize: CGSize = .zero
    let windowManager: SettingsWindowManager
    @ObservedObject var selection: Coordinator
    
    // MARK: - Coordinator
    class Coordinator: NSObject, ObservableObject {
        @Published var index: Int = 0
        weak var manager: SettingsWindowManager?
        init(manager: SettingsWindowManager?) {
            self.manager = manager
        }
    }
    
    // MARK: - Content Switch
    @ViewBuilder
    func contentView(for index: Int) -> some View {
        switch index {
            case 0: GeneralSettingsView()
            case 1: TranslationSettingsView()
            case 2: QuickActionSettingsView()
            case 3: AboutSettingsView()
            default: GeneralSettingsView()
        }
    }
    
    // MARK: - Body
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
            
            ZStack {
                contentView(for: selection.index)
                    .padding()
            }
        }
        .padding()
    }
}
