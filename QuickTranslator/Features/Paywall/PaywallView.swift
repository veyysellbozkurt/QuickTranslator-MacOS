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
            
            VStack {
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
                    VStack(spacing: 40) {
                        
                        // Header
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
                            
                            Text("Sınırsız Çeviriye Geç")
                                .font(.appLargeHeader())
                                .foregroundColor(.white)
                            
                            Text("Tüm özellikler sende, sadece limit kalkıyor.")
                                .font(.appTitle())
                                .foregroundColor(.white.opacity(0.7))
                        }
                                                
                        // Free Features Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Ücretsiz Kullanabileceğin Özellikler 🎁")
                                .font(.appTitle())
                                .foregroundColor(.white.opacity(0.7))
                                
                            
                            VStack(spacing: 16) {
                                FeatureRow(icon: "moon.circle.fill",
                                           title: "Koyu / Açık Mod",
                                           subtitle: "İstediğin tema stilini seç ve anında değiştir")

                                FeatureRow(icon: "rectangle.split.2x1.fill",
                                           title: "Dikey ve Yatay Yerleşim",
                                           subtitle: "Çeviri penceresini dilediğin düzende kullan")

                                FeatureRow(icon: "bolt.circle.fill",
                                           title: "Anında Çeviri (Floating Icon)",
                                           subtitle: "Ekrandaki metinleri tek tıkla çevir")

                                FeatureRow(icon: "menubar.rectangle",
                                           title: "Menü Çubuğu İkon Seçimi",
                                           subtitle: "Menü çubuğundaki uygulama ikonunu kişiselleştir")

                                FeatureRow(icon: "wifi.slash",
                                           title: "Çevrimdışı Çeviri",
                                           subtitle: "İnternet bağlantısı olmadan çeviri yap")

                            }
                        }
                        .padding(.horizontal, 40)
                        
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
                        
                        // Subscribe Button
                        Button(action: {
                        }) {
                            HStack {
                                Text(selectedPlan == .yearly ? "7 Gün Ücretsiz Dene" : "3 Gün Ücretsiz Dene")
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
                            .cornerRadius(16)
                            .shadow(color: .blue.opacity(0.5), radius: 20, x: 0, y: 10)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Restore and Terms
                        VStack(spacing: 12) {
                            // Restore Purchase
                            Button(action: {
                            }) {
                                Text("Satın Alımı Geri Yükle")
                                    .font(.appSmallTitle13())
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            
                            // Terms
                            HStack(spacing: 24) {
                                Button("Gizlilik Politikası") {
                                }
                                
                                Text("•")
                                
                                Button("Kullanım Şartları") {
                                }
                            }
                            .font(.appSmallTitle13())
                            .foregroundColor(.white.opacity(0.5))
                        }
                        .padding(.bottom, 30)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}
