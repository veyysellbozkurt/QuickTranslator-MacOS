//
//  AboutSettingsView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 6.10.2025.
//

import SwiftUI

struct AboutSettingsView: View {        
    
    var body: some View {
        VStack(spacing: 16) {
            Image(nsImage: FeatureManager.shared.menuBarIcon.image)
                .resizable()
                .frame(width: 80, height: 80)
            
            VStack(spacing: 4) {
                Text(Constants.appName)
                    .font(.appFont(.extraBold, size: 20))
                    .foregroundStyle(.textPrimary)
                Text(String(format: Constants.Strings.versionPrefix, Constants.appVersion))
                    .font(.appCaption())
                    .foregroundColor(.textSecondary)
            }
            
            Text(Constants.Strings.aboutAppDescription)
                .font(.appSmallTitle())
                .foregroundColor(.textSecondary)
            
            Divider()
            
            HStack(spacing: 16) {
                RateButton(action: openStoreReview)
                
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
                
                FeedbackButton(action: { MailAppHelper.openMailApp() })
            }
            
            VStack(spacing: 6) {
                Text(String(format: Constants.Strings.enjoyAppTitle, Constants.appName))
                    .font(.appTitle())
                    .foregroundStyle(.textPrimary)
                Text(Constants.Strings.enjoyAppDescription)
                    .font(.appCaption())
                    .foregroundStyle(.textSecondary)
            }
            .padding(.top, 4)
        }
        .frame(height: 300)
    }
}

private struct RateButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 16, weight: .medium))
                Text(Constants.Strings.rateButtonTitle)
                    .font(.appButton())
            }
            .padding(.horizontal, 8)
            .frame(height: 32)
            .background(
                Capsule()
                    .fill(.app.opacity(0.1))
            )
        }
        .buttonStyle(.plain)
        .foregroundStyle(.app)
        .overlay(
            Capsule()
                .stroke(.app.opacity(0.5), lineWidth: 1.2)
        )
        .help(Constants.Strings.rateButtonHelp)
    }
}

private struct FeedbackButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "envelope.fill")
                    .font(.system(size: 16, weight: .medium))
                Text(Constants.Strings.feedbackButtonTitle)
                    .font(.appButton())
            }
            .padding(.horizontal, 8)
            .frame(height: 32)
            .background(
                Capsule()
                    .fill(.app.opacity(0.1))
            )
        }
        .buttonStyle(.plain)
        .foregroundStyle(.app)
        .overlay(
            Capsule()
                .stroke(.app.opacity(0.5), lineWidth: 1.2)
        )
        .help(Constants.Strings.feedbackButtonHelp)
    }
}

private extension AboutSettingsView {
    func openStoreReview() {
        guard let url = Constants.Urls.appStoreReviewURL else { return }
        NSWorkspace.shared.open(url)
    }
}
