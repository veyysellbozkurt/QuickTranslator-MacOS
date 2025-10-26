//
//  TranslationSettingsView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 6.10.2025.
//

import SwiftUI
import AppKit

enum TranslationEngine: String, CaseIterable, Identifiable {
    case apple = "apple"
    case google = "google"

    var id: String { rawValue }
    var title: String {
        switch self {
        case .apple: return "Apple Translate"
        case .google: return "Google Translate"
        }
    }
    var subtitle: String {
        switch self {
        case .apple: return "Offline support — limited languages"
        case .google: return "Online — full language coverage"
        }
    }
    var systemImage: String {
        switch self {
        case .apple: return "applelogo"
        case .google: return "globe"
        }
    }
}

final class TranslationSettingsViewModel: ObservableObject {
    @Published var engine: TranslationEngine
    @Published var supportedLanguageCount: Int
    @Published var didOpenSystemSettings = false

    init(engine: TranslationEngine = .google, supportedLanguageCount: Int = 21) {
        self.engine = engine
        self.supportedLanguageCount = supportedLanguageCount
    }

    func openSystemSettings() {
        guard let url = URL(string: "x-apple.systempreferences:com.apple.Localization-Settings.Extension") else { return }
        if NSWorkspace.shared.open(url) {
            // small delay may be needed on real device; we set flag immediately for simple UX
            didOpenSystemSettings = true
        } else {
            // fallback: try plain settings URL or do nothing
            didOpenSystemSettings = true // still reveal steps so user can follow manually
        }
    }
}

struct TranslationSettingsView: View {
    @StateObject private var vm = TranslationSettingsViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            engineSection
            appleDetailsSection
            googleDetailsSection
        }
        .padding()
        .frame(height: 310)
    }

    // MARK: - Engine Picker Section
    private var engineSection: some View {
            SettingsSection(title: Constants.Strings.translationEngineTitle) {
                Picker("Engine   ", selection: $vm.engine) {
                    ForEach(TranslationEngine.allCases) { engine in
                        Label(engine.title, systemImage: engine.systemImage)
                            .tag(engine)
                            .font(.appSmallTitle())
                            .padding(.leading, 4)
                    }
                }
                .pickerStyle(.radioGroup)
                .tint(.app)
                .font(.appSmallTitle())

                Text(Constants.Strings.translationEngineDescription)
                    .font(.appCaption())
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.secondary)
                    .padding(.top, 8)
            }
        }

    // MARK: - Apple Engine Details Section
    @ViewBuilder
    private var appleDetailsSection: some View {
            if vm.engine == .apple {
                SettingsSection(title: Constants.Strings.appleTranslateTitle) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: vm.engine.systemImage)
                                .font(.appTitle())
                                .frame(width: 36, height: 36)
                                .foregroundStyle(.primary)

                            VStack(alignment: .leading, spacing: 6) {
                                Text(vm.engine.title).font(.appTitle())
                                Text(vm.engine.subtitle)
                                    .font(.appSmallTitle())
                                    .foregroundStyle(.secondary)
                            }
                        }

                        InfoCard(title: Constants.Strings.appleOfflineModeEnabled,
                                 message: Constants.Strings.appleOfflineMessage) {
                            Button(action: { vm.openSystemSettings() }) {
                                Label(Constants.Strings.openSettings, systemImage: "gearshape")
                                    .font(.appButton())
                            }
                            .buttonStyle(.borderedProminent)
                        }

                        if vm.didOpenSystemSettings {
                            StepsListViewSimple(steps: [
                                Constants.Strings.appleStep1,
                                Constants.Strings.appleStep2,
                                Constants.Strings.appleStep3
                            ])
                        } else {
                            Text(String(format: Constants.Strings.appleSupportedLanguagesMessage,
                                        vm.supportedLanguageCount))
                                .font(.appCaption())
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }

    // MARK: - Google Engine Details Section
    @ViewBuilder
    private var googleDetailsSection: some View {
            if vm.engine == .google {
                SettingsSection(title: Constants.Strings.googleTranslateTitle) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .top, spacing: 6) {
                            Image(systemName: vm.engine.systemImage)
                                .font(.appTitle())
                                .frame(width: 36, height: 36)
                                .foregroundStyle(.primary)

                            VStack(alignment: .leading, spacing: 6) {
                                Text(vm.engine.title).font(.appTitle())
                                Text(vm.engine.subtitle)
                                    .font(.appSmallTitle())
                                    .foregroundStyle(.secondary)
                            }
                        }

                        InfoCard(title: Constants.Strings.googleUnlimitedSupportTitle,
                                 message: Constants.Strings.googleUnlimitedSupportMessage) {
                            EmptyView()
                        }
                    }
                }
            }
        }
}

// MARK: - Small reusable components

struct InfoCard<Content: View>: View {
    let title: String
    let message: String
    let trailing: () -> Content

    init(title: String, message: String, @ViewBuilder trailing: @escaping () -> Content) {
        self.title = title
        self.message = message
        self.trailing = trailing
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title).font(.appTitle())
                    Text(message).font(.appSmallTitle()).foregroundColor(.secondary)
                }
                Spacer()
                trailing()
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.secondary.opacity(0.06)))
    }
}

struct StepsListViewSimple: View {
    let steps: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(Constants.Strings.appleTranslateTitle)
                .font(.appTitle()).bold()

            ForEach(Array(steps.enumerated()), id: \.0) { idx, step in
                HStack(alignment: .top, spacing: 8) {
                    Text("\(idx + 1).")
                        .bold()
                        .frame(width: 20, alignment: .leading)
                    Text(step)
                        .font(.appSmallTitle())
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.secondary.opacity(0.2)))
    }
}
