//
//  PaywallView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 30.10.2025.
//

import SwiftUI
import RevenueCat

struct PaywallView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = PaywallViewModel()
    @State private var selectedPlan: PricingPlan = .yearly
    
    enum PricingPlan {
        case monthly, yearly
    }
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            VStack {
                ScrollView {
                    VStack(spacing: 40) {
                        headerView
                            .padding(.top, 12)
                        
                        featuresView
                            .padding(.horizontal, 40)
                        
                        // Pricing Cards
                        VStack(spacing: 16) {
                            ForEach(viewModel.items) { item in
                                PricingRowView(
                                    item: item,
                                    isSelected: selectedPlan == (item.title == "Yearly Plan" ? .yearly : .monthly)
                                ) {
                                    selectedPlan = item.title == "Yearly Plan" ? .yearly : .monthly
                                }
                            }
                        }
                        
                        restoreAndTermsView
                            .padding(.bottom, 30)
                    }
                    .padding(.horizontal, 20)
                }
                
                subscribeButton
            }
            .overlay(closeButton, alignment: .topLeading)
        }
        .loading(viewModel.isLoading)
        .task {
            await viewModel.loadPackages()
        }
    }
}

// MARK: - Subviews
private extension PaywallView {
    
    var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.1, green: 0.2, blue: 0.35),
                Color(red: 0.05, green: 0.15, blue: 0.25),
                Color.black
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    var headerView: some View {
        VStack(spacing: 8) {
            Image(systemName: "crown.fill")
                .font(.system(size: 50))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.yellow, .orange],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("Unlock Unlimited Translations")
                .font(.appLargeHeader())
                .foregroundColor(.white)
            
            Text("All features unlocked, no more limits.")
                .font(.appTitle())
                .foregroundColor(.white.opacity(0.7))
        }
    }
    
    var featuresView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Free Features 🎁")
                .font(.appTitle())
                .foregroundColor(.white.opacity(0.7))
            
            VStack(spacing: 16) {
                FeatureRow(icon: "moon.circle.fill",
                           title: "Dark / Light Mode",
                           subtitle: "Choose your preferred theme instantly")
                
                FeatureRow(icon: "rectangle.split.2x1.fill",
                           title: "Vertical and Horizontal Layout",
                           subtitle: "Use the translation window in your preferred layout")
                
                FeatureRow(icon: "bolt.circle.fill",
                           title: "Instant Translation (Floating Icon)",
                           subtitle: "Translate on-screen text with a single click")
                
                FeatureRow(icon: "menubar.rectangle",
                           title: "Menu Bar Icon Selection",
                           subtitle: "Customize the app icon in your menu bar")
                
                FeatureRow(icon: "wifi.slash",
                           title: "Offline Translation",
                           subtitle: "Translate even without an internet connection")
            }
        }
    }
    
    var restoreAndTermsView: some View {
        VStack(spacing: 12) {
            Button(action: {
                Task { @MainActor in
                    viewModel.showLoading()
                    defer { viewModel.hideLoading() }
                    await SubscriptionManager.shared.restorePurchases()
                }
            }) {
                Text("Restore Purchase")
                    .font(.appSmallTitle13())
                    .foregroundColor(.white.opacity(0.6))
            }
            
            HStack(spacing: 24) {
                Button("Privacy Policy") {
                    if let privacyURL = Constants.Urls.privacyURL {
                        NSWorkspace.shared.open(privacyURL)
                    }
                }
                
                Text("•")
                
                Button("Terms of Use") {
                    if let termsURL = Constants.Urls.privacyURL {
                        NSWorkspace.shared.open(termsURL)
                    }
                }
            }
            .font(.appSmallTitle13())
            .foregroundColor(.white.opacity(0.5))
        }
    }
    
    var subscribeButton: some View {
        Button(action: {
            // Satın alma işlemini burada başlatabilirsin
        }) {
            HStack {
                Text(selectedPlan == .yearly ? "7-Day Free Trial" : "3-Day Free Trial")
                    .font(.appExtraLargeTitle())
                
                Image(systemName: "arrow.right")
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [.blue, .cyan],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(14)
            .shadow(color: .blue.opacity(0.5), radius: 20, x: 0, y: 10)
        }
        .buttonStyle(BounceButtonStyle())
        .padding()
    }
    
    var closeButton: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(.white.opacity(0.7), .white.opacity(0.15))
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.leading, 20)
            .padding(.top, 10)
            
            Spacer()
        }
    }
}

// MARK: - PricingRowView
private struct PricingRowView: View {
    let item: PaywallViewModel.PricingItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        PricingCard(
            title: item.title,
            subtitle: item.subtitle,
            price: item.priceText,
            period: item.periodText,
            monthlyEquivalent: item.monthlyEquivalentText,
            discount: item.discountText,
            isSelected: isSelected,
            isRecommended: item.title == "Yearly Plan"
        ) {
            action()
        }
    }
}
