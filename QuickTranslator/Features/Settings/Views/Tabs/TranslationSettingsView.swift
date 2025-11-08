//
//  TranslationSettingsView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 6.10.2025.
//

import SwiftUI
import AppKit

struct TranslationSettingsView: View {
    @ObservedObject var featureManager = FeatureManager.shared
    @State private var didOpenSystemSettings = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            engineSection
            appleDetailsSection
            googleDetailsSection
        }
        .frame(height: 300)
    }

    // MARK: - Engine Picker Section
    private var engineSection: some View {
            SettingsSection(title: Constants.Strings.translationEngineTitle,
                            footnote: Constants.Strings.translationEngineDescription) {
                CompactSegmentedPicker(
                    options: TranslationServiceType.allCases,
                    selection: $featureManager.translationService,
                    iconProvider: \.systemImage,
                    titleProvider: \.title)
            }
        }

    // MARK: - Apple Engine Details Section
    @ViewBuilder
    private var appleDetailsSection: some View {
        if featureManager.translationService == .apple {
                SettingsSection(title: Constants.Strings.appleTranslateTitle) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: featureManager.translationService.systemImage)
                                    .font(.appTitle())
                                    .frame(width: 36, height: 36)
                                    .foregroundStyle(.textPrimary)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(featureManager.translationService.title).font(.appSmallTitle13())
                                    Text(featureManager.translationService.subtitle)
                                        .font(.appSmallTitle())
                                        .foregroundStyle(.textPrimary)
                                }
                            }
                            
                            InfoCard(title: Constants.Strings.appleOfflineModeEnabled,
                                     message: Constants.Strings.appleOfflineMessage) {
                                Button(action: { openSystemSettings() }) {
                                    Label(Constants.Strings.openSettings, systemImage: "gearshape")
                                        .font(.appButton())
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            
                            if didOpenSystemSettings {
                                StepsListViewSimple(steps: [
                                    Constants.Strings.appleStep1,
                                    Constants.Strings.appleStep2,
                                    Constants.Strings.appleStep3
                                ])
                            } else {
                                Text(String(format: Constants.Strings.appleSupportedLanguagesMessage,
                                            21))
                                .font(.appCaption())
                                .foregroundStyle(.textSecondary)
                            }
                        }
                    }
                }
            }
        }

    // MARK: - Google Engine Details Section
    @ViewBuilder
    private var googleDetailsSection: some View {
        if featureManager.translationService == .google {
                SettingsSection(title: Constants.Strings.googleTranslateTitle) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .top, spacing: 6) {
                            Image(systemName: featureManager.translationService.systemImage)
                                .font(.appTitle())
                                .frame(width: 36, height: 36)
                                .foregroundStyle(.textPrimary)

                            VStack(alignment: .leading, spacing: 6) {
                                Text(featureManager.translationService.title).font(.appSmallTitle13())
                                Text(featureManager.translationService.subtitle)
                                    .font(.appSmallTitle())
                                    .foregroundStyle(.textSecondary)
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
    
    func openSystemSettings() {
        guard let url = Constants.Urls.localizationSettingsURL else { return }
        if NSWorkspace.shared.open(url) {
            didOpenSystemSettings = true
        } else {
            didOpenSystemSettings = true
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
                    Text(title).font(.appSmallTitle13()).foregroundStyle(.textPrimary)
                    Text(message).font(.appSmallTitle()).foregroundColor(.textSecondary)
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
                .foregroundStyle(.textPrimary)

            ForEach(Array(steps.enumerated()), id: \.0) { idx, step in
                HStack(alignment: .top, spacing: 4) {
                    Text("\(idx + 1).")
                        .font(.appSmallTitle())
                        .foregroundStyle(.textPrimary)
                    Text(step)
                        .font(.appSmallTitle())
                        .foregroundStyle(.textPrimary)
                }
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 8).strokeBorder(.gray.opacity(0.1)))
    }
}
