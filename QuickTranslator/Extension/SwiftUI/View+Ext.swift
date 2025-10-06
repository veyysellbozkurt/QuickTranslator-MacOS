//
//  View+Ext.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 18.09.2025.
//

import SwiftUI

// MARK: - Show Toast
extension View {
    func toast(isPresented: Binding<Bool>, message: String, duration: TimeInterval = 1.0) -> some View {
        self.modifier(ToastModifier(isPresented: isPresented, message: message, duration: duration))
    }
}
