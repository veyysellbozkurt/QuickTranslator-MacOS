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
    
    init(isPresented: Binding<Bool>, message: String, duration: TimeInterval = 1.0) {
        self._isPresented = isPresented
        self.message = message
        self.duration = duration
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                VStack {
                    Spacer()
                    Text(message)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 40)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                                withAnimation {
                                    isPresented = false
                                }
                            }
                        }
                }
                .animation(.easeInOut, value: isPresented)
            }
        }
    }
}

extension View {
    func toast(isPresented: Binding<Bool>, message: String, duration: TimeInterval = 1.0) -> some View {
        self.modifier(ToastModifier(isPresented: isPresented, message: message, duration: duration))
    }
}
