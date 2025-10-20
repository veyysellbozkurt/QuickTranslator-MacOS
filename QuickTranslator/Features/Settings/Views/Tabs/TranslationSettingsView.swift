//
//  TranslationSettingsView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 6.10.2025.
//

// TranslationSettingsView_Simplified.swift
// QuickTranslator
// Refactor by ChatGPT — simplified structure, UI and UX

import SwiftUI
import AppKit

/// Simple, single-file replacement for the original TranslationSettingsView.
/// Key ideas:
///  - Use a compact Picker (segmented) for engine selection instead of custom card buttons.
///  - Keep explanatory text short and contextual.
///  - Reduce nesting and duplicated components.
///  - Make Offline instructions a single clear CTA that reveals steps after opening System Settings.
///  - Separate ViewModel for logic so view is lightweight and testable.

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
            header

            enginePicker

            Divider()

            details
        }
//        .padding()
        .frame(minWidth: 360)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Translation Engine")
                .font(.title3).bold()

            Text("Pick an engine. Apple works offline for some languages; Google provides the broadest online coverage.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var enginePicker: some View {
        Picker("Engine", selection: $vm.engine) {
            ForEach(TranslationEngine.allCases) { engine in
                Label(engine.title, systemImage: engine.systemImage)
                    .tag(engine)
            }
        }
        .pickerStyle(.segmented)
        .accessibilityLabel(Text("Translation engine"))
    }

    @ViewBuilder
    private var details: some View {
        switch vm.engine {
        case .apple:
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: vm.engine.systemImage)
                        .frame(width: 36, height: 36)
                        .font(.title2)
                        .foregroundStyle(.primary)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(vm.engine.title).font(.headline)
                        Text(vm.engine.subtitle).font(.subheadline).foregroundColor(.secondary)
                    }
                }

                InfoCard(title: "Offline Mode Enabled", message: "You can download languages for offline use via System Settings.") {
                    Button(action: { vm.openSystemSettings() }) {
                        Label("Open System Settings", systemImage: "gearshape")
                    }
                    .buttonStyle(.borderedProminent)
                }

                if vm.didOpenSystemSettings {
                    StepsListViewSimple(steps: [
                        "Open System Settings → General",
                        "Choose Language & Region",
                        "Open Translation Languages and download desired languages"
                    ])
                } else {
                    Text("Apple supports approximately \(vm.supportedLanguageCount) languages for offline translation.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .transition(.opacity.combined(with: .move(edge: .top)))

        case .google:
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: vm.engine.systemImage)
                        .frame(width: 36, height: 36)
                        .font(.title2)
                        .foregroundStyle(.primary)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(vm.engine.title).font(.headline)
                        Text(vm.engine.subtitle).font(.subheadline).foregroundColor(.secondary)
                    }
                }

                InfoCard(title: "Unlimited Language Support", message: "Uses online APIs for broad language coverage. Requires network access.") {
                    EmptyView()
                }
            }
            .transition(.opacity.combined(with: .move(edge: .bottom)))
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
                    Text(title).bold()
                    Text(message).font(.subheadline).foregroundColor(.secondary)
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
            Text("Steps to download languages:")
                .font(.subheadline).bold()

            ForEach(Array(steps.enumerated()), id: \ .0) { idx, step in
                HStack(alignment: .top, spacing: 8) {
                    Text("\(idx + 1).")
                        .bold()
                        .frame(width: 20, alignment: .leading)
                    Text(step)
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.secondary.opacity(0.2)))
    }
}

// MARK: - Preview

struct TranslationSettingsView_Simplified_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TranslationSettingsView()
                .previewDisplayName("Simplified - Google")

            TranslationSettingsView()
                .previewDisplayName("Simplified - Apple")
                .onAppear {
                    // can't mutate preview VM easily; this is illustrative
                }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
