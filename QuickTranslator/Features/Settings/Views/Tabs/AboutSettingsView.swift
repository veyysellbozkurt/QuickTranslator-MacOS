//
//  AboutSettingsView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 6.10.2025.
//

import SwiftUI

struct AboutSettingsView: View {
    
    private var appName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Quick Translator"
    }
    
    private var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
    }
        
    private let appStoreReviewURLString = "https://apps.apple.com/app/idYOUR_APP_ID?action=write-review"
    
    var body: some View {
        VStack(spacing: 16) {
            Image(nsImage: FeatureManager.shared.menuBarIcon.image)
                .resizable()
                .foregroundColor(.app)
                .frame(width: 80, height: 80)
            
            VStack(spacing: 4) {
                Text(appName).font(.title).bold()
                Text("Version \(appVersion)").font(.subheadline).foregroundColor(.secondary)
            }
            
            Text("A fast and efficient translation tool for macOS.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                        
            Divider()
                        
            HStack(spacing: 16) {
                Group {
                    RateButton(action: openStoreReview)
                    
                    // Buy Me a Coffee görsel buton
                    Button {
                        NSWorkspace.shared.open(Constants.Urls.buyMeCoffee)
                    } label: {
                        Image(.buyMeCoffee)
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(height: 30)
                    .clipShape(.buttonBorder)
                    .buttonStyle(BounceButtonStyle())
                    
                    // Send Feedback (varsayılan e‑posta uygulamasını açar)
                    Button("Send Feedback") {
                        openEmail(
                            to: "veyysellbozkrt@gmail.com",
                            subject: "Feedback for \(appName) v\(appVersion)",
                            body: """
                            Hi,

                            Here is my feedback for \(appName) v\(appVersion):

                            - What I liked:
                            - What can be improved:
                            - Suggestions:

                            Thanks!
                            """
                        )
                    }
                }
                .buttonStyle(.borderedProminent)
                .foregroundStyle(.app)
            }
            
            // Küçük bilgilendirme: oy vermeyi teşvik
            VStack(spacing: 6) {
                Text("Enjoying \(appName)?")
                    .font(.headline)
                Text("Your rating helps others discover the app and supports future improvements.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.top, 4)
        }
        .padding(20)
    }
}

private extension AboutSettingsView {
    func openEmail(to: String, subject: String, body: String) {
        let allowed = CharacterSet.urlQueryAllowed
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: allowed) ?? ""
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: allowed) ?? ""
        
        let urlString = "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)"
        if let url = URL(string: urlString) {
            NSWorkspace.shared.open(url)
        }
    }
    
    func openStoreReview() {
        guard let url = URL(string: appStoreReviewURLString) else { return }
        NSWorkspace.shared.open(url)
    }
}

// MARK: - Custom Rate Button
private struct RateButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 16, weight: .medium))
                Text("Rate on the App Store")
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.app.opacity(0.15))
            )
        }
        .buttonStyle(.plain) // İçeride kendi görselleştirmemiz var
        .foregroundStyle(.app)
        .overlay(
            Capsule()
                .stroke(Color.app.opacity(0.5), lineWidth: 1)
        )
        .contentShape(Capsule())
        .help("Open the App Store review page")
        .accessibilityLabel("Rate on the App Store")
    }
}
