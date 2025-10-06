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
    
    @State private var timer: Timer?
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                VStack {
                    Text(message)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color(nsColor: .windowBackgroundColor))
                        .foregroundColor(.primary)
                        .cornerRadius(10)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.primary.opacity(0.2), lineWidth: 1)
                        )
                        .padding(.bottom, 10)
                }
            }
        }
        .onChange(of: isPresented) { _, newValue in
            if newValue {
                resetTimer()
            } else {
                timer?.invalidate()
                timer = nil
            }
        }
        .animation(.easeInOut, value: isPresented)
    }
    
    private func resetTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
            withAnimation {
                isPresented = false
            }
        }
    }
}
