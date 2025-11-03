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
    
    @State private var hoveredOption: T?
    @Namespace private var animation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {            
            HStack(spacing: 2) {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.9)) {
                            selection = option
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: iconProvider(option))
                                .font(.system(size: 14, weight: .medium))
                            
                            Text(titleProvider(option))
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundColor(selection == option ? .white : .primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            ZStack {
                                if selection == option {
                                    Capsule()
                                        .fill(Color.accentColor)
                                        .matchedGeometryEffect(id: "segmentBackground", in: animation)
                                }
                            }
                        )
                        .contentShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .onHover { hovering in
                        hoveredOption = hovering ? option : nil
                    }
                }
            }
            .padding(4)
            .background(
                Capsule()
                    .fill(Color(NSColor.controlBackgroundColor))
            )
        }
        .background(
            Capsule()
                .fill(Color(NSColor.textBackgroundColor))
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        )
    }
}
