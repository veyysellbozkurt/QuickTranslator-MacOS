//
//  TranslationSettingsView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 6.10.2025.
//

import SwiftUI
import AppKit

struct TranslationSettingsView: View {
    @ObservedObject private var featureManager = FeatureManager.shared
    @State private var showSystemSteps = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SettingsSection(title: "Translation Engine") {
                Text("Choose which translation engine to use.")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                
                HStack(spacing: 20) {
                    EngineCard(
                        title: "Apple Translate",
                        subtitle: "Works completely offline.\nLimited language support and quality.",
                        image: Image(systemName: "applelogo"),
                        isSelected: featureManager.translationService == .apple
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            featureManager.translationService = .apple
                        }
                    }
                    
                    EngineCard(
                        title: "Google Translate",
                        subtitle: "Versatile online translations. Requires an internet connection.",
                        image: Image(systemName: "globe"),
                        isSelected: featureManager.translationService == .google
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            featureManager.translationService = .google
                        }
                    }
                }
            }
            
            SettingsSection(title: "") {
                ZStack {
                    if featureManager.translationService == .apple {
                        OfflineInfo(showSystemSteps: $showSystemSteps)
                            .transition(.opacity.combined(with: .scale(scale: 0.98)))
                            .id("appleInfo")
                    } else {
                        InfoBox(
                            title: "Unlimited Language Support",
                            message: "SwiftyTranslate uses online APIs to support almost all major world languages."
                        )
                        .transition(.opacity.combined(with: .scale(scale: 0.98)))
                        .id("googleInfo")
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: featureManager.translationService)
            }
        }
        .padding()
    }
}

private struct EngineCardStyle: ButtonStyle {
    let isSelected: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.accentColor.opacity(0.12) : Color(.windowBackgroundColor))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.accentColor : Color.gray.opacity(0.4), lineWidth: 1.5)
                    )
            )
    }
}

struct EngineCard: View {
    let title: String
    let subtitle: String
    let image: Image
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundColor(isSelected ? .accentColor : .secondary)
                    .accessibilityHidden(true)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline.bold())
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(EngineCardStyle(isSelected: isSelected))
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? [.isSelected, .isButton] : .isButton)
        .accessibilityLabel(Text(title))
        .accessibilityHint(Text("Click to select"))
    }
}

private final class OfflineInfoViewModel: ObservableObject {
    @Published var showSystemSteps = false
    let supportedLanguageCount: Int
    let systemSteps: [String]
    let systemURL: URL?
    
    init(
        supportedLanguageCount: Int = 21,
        systemSteps: [String] = [
            "Open the **General** section.",
            "Go to **Language & Region**.",
            "Click the **‘Translation Languages…’** button at the bottom."
        ],
        systemURL: URL? = URL(string: "x-apple.systempreferences:com.apple.Localization-Settings.Extension")
    ) {
        self.supportedLanguageCount = supportedLanguageCount
        self.systemSteps = systemSteps
        self.systemURL = systemURL
    }
    
    func openSystemSettings() {
        guard let url = systemURL else { return }
        if NSWorkspace.shared.open(url) {
            showSystemSteps = true
        } else {
            Logger.warning("Failed to open System Settings URL: \(url.absoluteString)")
        }
    }
}

struct OfflineInfo: View {
    @Binding var showSystemSteps: Bool
    @StateObject private var viewModel = OfflineInfoViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            InfoBox(
                title: "Offline Mode Enabled",
                message: "You need to download languages for offline translation. Downloading and language management are handled via macOS System Settings."
            )
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Apple Translate Supported Languages: \(viewModel.supportedLanguageCount)")
                    .font(.headline)
                    .padding(.bottom, 5)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                
                Text("The full list of these languages and their download status can be viewed in the macOS **Translation Languages** window.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("To download languages, you need to go to System Settings.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                
                HStack(alignment: .top) {
                    if showSystemSteps || viewModel.showSystemSteps {
                        StepsListView(steps: viewModel.systemSteps)
                            .transition(.opacity.combined(with: .scale(scale: 0.98)))
                    } else {
                        Button {
                            viewModel.openSystemSettings()
                            showSystemSteps = viewModel.showSystemSteps
                        } label: {
                            Label("Open System Settings", systemImage: "gearshape.fill")
                                .multilineTextAlignment(.leading)
                        }
                        .buttonStyle(.borderedProminent)
                        .accessibilityLabel(Text("Open System Settings"))
                        .accessibilityHint(Text("Opens System Settings to download translation languages"))
                        .transition(.opacity.combined(with: .scale(scale: 0.98)))
                    }
                    Spacer()
                }
            }
        }
    }
}

private struct StepsListView: View {
    let steps: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Please follow these steps in the **System Settings** window that just opened:")
                .font(.subheadline).bold()
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
            VStack(alignment: .leading, spacing: 4) {
                ForEach(steps.indices, id: \.self) { index in
                    HStack(spacing: 8) {
                        Image(systemName: "\(index + 1).circle.fill")
                            .foregroundColor(.accentColor)
                            .accessibilityHidden(true)
                        Text(.init(steps[index]))
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .padding(12)
        .background(Color.accentColor.opacity(0.1))
        .cornerRadius(8)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(Text("System Settings steps"))
    }
}

struct InfoBox: View {
    let title: String
    let message: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline.bold())
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.secondary.opacity(0.08))
        )
    }
}

#Preview {
    TranslationSettingsView()
        .padding()
}
