//
//  ToastModifier.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 8.09.2025.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let duration: TimeInterval
    var icon: String? = nil

    @State private var timer: Timer?

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                toastView
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.9).combined(with: .opacity).combined(with: .move(edge: .bottom)),
                        removal: .opacity.combined(with: .move(edge: .bottom))
                    ))
                    .zIndex(10)
                    .padding(.bottom, 24)
            }
        }
        .onChange(of: isPresented) { _, newValue in
            if newValue {
                startTimer()
            } else {
                stopTimer()
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: isPresented)
    }

    // MARK: - Toast View
    private var toastView: some View {
        HStack(spacing: 10) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.textPrimary.opacity(0.8))
                    .padding(.leading, 4)
            }

            Text(message)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.horizontal, 4)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(LinearGradient(
                            colors: [.textPrimary.opacity(0.3), .textPrimary.opacity(0.05)],
                            startPoint: .top, endPoint: .bottom
                        ), lineWidth: 1)
                )
                .shadow(color: .appWindowBackground.opacity(0.25), radius: 12, y: 8)
        )
        .frame(maxWidth: 280)
    }

    // MARK: - Timer Management
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
            withAnimation {
                isPresented = false
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

extension View {
    func toast(
        isPresented: Binding<Bool>,
        message: String,
        duration: TimeInterval = 2.5,
        icon: String? = nil
    ) -> some View {
        modifier(ToastModifier(isPresented: isPresented, message: message, duration: duration, icon: icon))
    }
}
