//
//  PricingCard.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 2.11.2025.
//

import SwiftUI

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
            VStack {
                if isRecommended {
                    HStack {
                        Spacer()
                        
                        Text(discount ?? "En Popüler")
                            .font(.appSmallTitle13())
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
                            .font(.appExtraLargeTitle())
                            .foregroundColor(.white)
                        
                        Text(subtitle)
                            .font(.appSmallTitle13())
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text(price)
                                .font(.appLargeHeader())
                                .foregroundColor(.white)
                            
                            Text(period)
                                .font(.appTitle())
                                .foregroundColor(.white.opacity(0.6))
                        }
                        
                        if let monthly = monthlyEquivalent {
                            Text(monthly)
                                .font(.appSmallTitle())
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
