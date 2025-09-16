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
                        .background(.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
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

extension View {
    func toast(isPresented: Binding<Bool>, message: String, duration: TimeInterval = 1.0) -> some View {
        self.modifier(ToastModifier(isPresented: isPresented, message: message, duration: duration))
    }
}
