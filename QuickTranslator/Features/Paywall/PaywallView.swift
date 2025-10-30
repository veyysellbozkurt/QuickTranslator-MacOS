//
//  PremiumView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 30.10.2025.
//

import SwiftUI

struct PaywallView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedPlan: PricingPlan = .yearly
    
    enum PricingPlan {
        case monthly, yearly
    }
    
    var body: some View {
        ZStack {
            // Gradient Background
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
            
            VStack(spacing: 0) {
                // Close Button
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
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Header
                        VStack(spacing: 12) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.yellow, .orange],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .padding(.top, 20)
                            
                            Text("Premium'a Yükselt")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Tüm özelliklerin kilidini aç ve sınırsız kullan")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        
                        // Features
                        VStack(spacing: 16) {
                            FeatureRow(
                                icon: "infinity",
                                title: "Sınırsız Çeviri",
                                subtitle: "Günlük limit olmadan kullan"
                            )
                            
                            FeatureRow(
                                icon: "camera.viewfinder",
                                title: "OCR Çeviri",
                                subtitle: "Görsellerden metin çevir"
                            )
                            
                            FeatureRow(
                                icon: "speaker.wave.3.fill",
                                title: "Yüksek Kalite Ses",
                                subtitle: "Profesyonel sesli okuma"
                            )
                            
                            FeatureRow(
                                icon: "sparkles",
                                title: "Öncelikli Destek",
                                subtitle: "7/24 premium destek"
                            )
                            
                            FeatureRow(
                                icon: "arrow.down.circle.fill",
                                title: "Çevrimdışı Mod",
                                subtitle: "İnternetsiz kullan"
                            )
                            
                            FeatureRow(
                                icon: "paintbrush.fill",
                                title: "Özel Temalar",
                                subtitle: "Premium tema koleksiyonu"
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        // Pricing Cards
                        VStack(spacing: 16) {
                            // Yearly Plan (Recommended)
                            PricingCard(
                                title: "Yıllık Plan",
                                subtitle: "7 gün ücretsiz dene",
                                price: "₺399,99",
                                period: "/ Yıl",
                                monthlyEquivalent: "₺33,33 / Ay",
                                discount: "33% İndirim",
                                isSelected: selectedPlan == .yearly,
                                isRecommended: true
                            ) {
                                selectedPlan = .yearly
                            }
                            
                            // Monthly Plan
                            PricingCard(
                                title: "Aylık Plan",
                                subtitle: "3 gün ücretsiz dene",
                                price: "₺49,99",
                                period: "/ Ay",
                                monthlyEquivalent: nil,
                                discount: nil,
                                isSelected: selectedPlan == .monthly,
                                isRecommended: false
                            ) {
                                selectedPlan = .monthly
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Subscribe Button
                        Button(action: {
                            // Subscribe action
                        }) {
                            HStack {
                                Text(selectedPlan == .yearly ? "7 Gün Ücretsiz Dene" : "3 Gün Ücretsiz Dene")
                                    .font(.system(size: 18, weight: .semibold))
                                
                                Image(systemName: "arrow.right")
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                LinearGradient(
                                    colors: [.blue, .cyan],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: .blue.opacity(0.5), radius: 20, x: 0, y: 10)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        // Restore Purchase
                        Button(action: {
                            // Restore action
                        }) {
                            Text("Satın Alımı Geri Yükle")
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .padding(.top, 8)
                        
                        // Terms
                        HStack(spacing: 20) {
                            Button("Gizlilik Politikası") {
                                // Privacy action
                            }
                            
                            Text("•")
                            
                            Button("Kullanım Şartları") {
                                // Terms action
                            }
                        }
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.5))
                        .padding(.bottom, 30)
                    }
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue.opacity(0.3), .cyan.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(.cyan)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(.green)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.white.opacity(0.05))
        )
    }
}

struct PricingCard: View {
    let title: String
    let subtitle: String
    let price: String
    let period: String
    let monthlyEquivalent: String?
    let discount: String?
    let isSelected: Bool
    let isRecommended: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                // Recommended Badge
                if isRecommended {
                    HStack {
                        Spacer()
                        
                        Text(discount ?? "En Popüler")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                LinearGradient(
                                    colors: [.purple, .pink],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(20)
                        
                        Spacer()
                    }
                    .offset(y: -8)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(title)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(subtitle)
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text(price)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.cyan)
                            
                            Text(period)
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        
                        if let monthly = monthlyEquivalent {
                            Text(monthly)
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                }
                .padding(20)
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(
                        isSelected ?
                            LinearGradient(
                                colors: [.cyan, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                colors: [.white.opacity(0.2), .white.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                        lineWidth: isSelected ? 2 : 1
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                isSelected ?
                                    .white.opacity(0.1) :
                                    .white.opacity(0.05)
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    PaywallView()
}
