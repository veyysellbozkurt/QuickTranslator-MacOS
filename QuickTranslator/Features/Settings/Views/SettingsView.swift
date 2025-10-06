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
                case 2: ShortcutsSettingsView()
                case 3: AboutSettingsView(windowManager: windowManager)
                default: GeneralSettingsView()
            }
        }
    }
    
    var body: some View {
        let tabs: [TabItem] = [
            .init(label: "General", systemImageName: "gear"),
            .init(label: "Translation", systemImageName: "globe"),
            .init(label: "Shortcuts", systemImageName: "keyboard"),
            .init(label: "About", systemImageName: "info.circle"),
        ]
        
        VStack {
            CustomTabBar(tabs: tabs, selectedIndex: $selection.index)
            Divider()
            contentView(selection: selection)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct SettingsSection<Content: View>: View {
    let title: String
    let content: () -> Content
    
    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title.uppercased())
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            
            VStack(alignment: .leading, spacing: 10) {
                content()
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(nsColor: .controlBackgroundColor)))
        }
    }
}

struct SettingsToggle: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
    }
}

struct SettingsPicker: View {
    let title: String
    @Binding var selection: String
    let options: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Picker("", selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 220)
        }
    }
}

struct SettingsSlider: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let minLabel: String
    let maxLabel: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Slider(value: $value, in: range, step: step)
                .frame(width: 220)
            HStack {
                Text(minLabel)
                Spacer()
                Text(maxLabel)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }
}

struct SettingsStepper: View {
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let step: Int
    
    var body: some View {
        HStack {
            Text("\(title): \(value)")
            Spacer()
            Stepper("", value: $value, in: range, step: step)
                .labelsHidden()
        }
    }
}

struct SettingsShortcut: View {
    let title: String
    let keys: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(keys)
                .font(.system(.body, design: .monospaced))
                .padding(4)
                .background(Color.secondary.opacity(0.2))
                .cornerRadius(4)
        }
    }
}
