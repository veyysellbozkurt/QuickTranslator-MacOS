//
//  BePremiumButton.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 29.10.2025.
//

import SwiftUI

struct BePremiumButton: View {
    var title: String = "Upgrade to Premium"
    var badgeText: String? = nil
    var icon: String = "sparkles"
    var gradient: LinearGradient = LinearGradient(
        colors: [Color.premiumGradientStart, Color.premiumGradientEnd],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    var action: () -> Void = {}
    
    // Animasyon state'i
    @State private var wave = false
    
    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                HStack(spacing: 8) {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                    Text(title)
                        .font(.appSmallTitle())
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 4)
                .background(
                    gradient
                        .cornerRadius(8)
                        .shadow(color: .purple.opacity(0.3), radius: 6, x: 0, y: 3)
                )
                .rotationEffect(.degrees(wave ? 0.6 : -0.6))
                .animation(
                    Animation.easeInOut(duration: 0.5)
                        .repeatForever(autoreverses: true),
                    value: wave
                )
                
                if let badge = badgeText {
                    Text(badge)
                        .font(.caption2.bold())
                        .padding(.horizontal, 6)
                        .padding(.vertical, 0)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .offset(x: 10, y: -8)
                        .transition(.scale)
                }
            }
        }
        .buttonStyle(.plain)
        .onAppear {
            wave.toggle()
        }
    }
}
