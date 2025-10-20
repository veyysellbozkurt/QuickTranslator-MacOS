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
    @State private var previousIndex = 0
    
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
                    .id(selection.index)
                    .transition(.asymmetric(
                        insertion: .move(edge: selection.index > previousIndex ? .trailing : .leading).combined(with: .opacity),
                        removal: .move(edge: selection.index > previousIndex ? .leading : .trailing).combined(with: .opacity)
                    ))
                    .animation(.easeInOut(duration: 0.35), value: selection.index)
                
                SizeReader { size in
                    windowManager.updateWindowHeight(to: size.height)
                }
                .allowsHitTesting(false)
            }
            .onChange(of: selection.index) {
                previousIndex = selection.index
            }
        }
        .padding()
    }
}

struct SizeReader: View {
    var onChange: (CGSize) -> Void
    
    var body: some View {
        GeometryReader { geo in
            Color.clear
                .onAppear { onChange(geo.size) }
                .onChange(of: geo.size) {
                    onChange(geo.size)
                }
        }
    }
}
