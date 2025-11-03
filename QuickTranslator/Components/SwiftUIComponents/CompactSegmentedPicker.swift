//
//  CompactSegmentedPicker.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 3.11.2025.
//

import SwiftUI

struct CompactSegmentedPicker<T: Hashable>: View {
    let options: [T]
    @Binding var selection: T
    let iconProvider: (T) -> String
    let titleProvider: (T) -> String

    @Namespace private var animation
    
    // Küçük yardımcı hesaplamalar
    private func buttonColor(for option: T) -> Color {
        selection == option ? .white : .primary
    }
    
    private func background(for option: T) -> some View {
        Group {
            if selection == option {
                Capsule()
                    .fill(Color.app)
                    .matchedGeometryEffect(id: "segmentBackground", in: animation)
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(options, id: \.self) { option in
                Button {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                        selection = option
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: iconProvider(option))
                            .font(.system(size: 14, weight: .medium))
                        Text(titleProvider(option))
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundColor(buttonColor(for: option))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(background(for: option))
                    .contentShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(
            Capsule()
                .fill(Color(NSColor.controlBackgroundColor))
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 1)
        )
    }
}
