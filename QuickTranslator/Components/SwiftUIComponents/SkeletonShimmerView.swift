//
//  SkeletonShimmerView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 13.11.2025.
//

import SwiftUI

struct SkeletonShimmerView: View {
    @State private var phase: CGFloat = -0.5
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            shimmerLine(widthRatio: 0.9)
            shimmerLine(widthRatio: 0.9)
            shimmerLine(widthRatio: 0.8)
            shimmerLine(widthRatio: 0.7)
        }
        .padding(.horizontal)
        .padding(.bottom, 100)
        .onAppear {
            withAnimation(
                .linear(duration: 1.2)
                .repeatForever(autoreverses: false)
            ) {
                phase = 1.5
            }
        }
    }
    
    private func shimmerLine(widthRatio: CGFloat) -> some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.25))
                .frame(width: geometry.size.width * widthRatio, height: 16)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .gray.opacity(0.2),
                            .gray.opacity(0.5),
                            .gray.opacity(0.2)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .mask(
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        .white.opacity(0),
                                        .white.opacity(0.9),
                                        .white.opacity(0)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .rotationEffect(.degrees(20))
                            .offset(x: geometry.size.width * phase)
                    )
                )
        }
        .frame(height: 14)
    }
}
