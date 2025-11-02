//
//  FeatureRow.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 2.11.2025.
//

import SwiftUI

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
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.cyan)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.appTitle())
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.appSmallTitle13())
                    .foregroundColor(.white.opacity(0.5))
            }
            
            Spacer()
            
            Image(systemName: "checkmark")
                .font(.system(size: 20))
                .fontWeight(.heavy)
                .foregroundColor(.controlGreen)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.white.opacity(0.05))
        )
    }
}
