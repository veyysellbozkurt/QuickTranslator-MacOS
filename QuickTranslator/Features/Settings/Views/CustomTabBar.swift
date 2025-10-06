//
//  CustomTabBar.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 5.10.2025.
//

import SwiftUI

struct TabItem: Identifiable, Equatable {
    let id = UUID()
    let label: String
    let systemImageName: String?   // SF Symbol
    let customImageName: String?   // Asset Image
    
    init(label: String, systemImageName: String? = nil, customImageName: String? = nil) {
        self.label = label
        self.systemImageName = systemImageName
        self.customImageName = customImageName
    }
}

struct CustomTabBar: View {
    
    let tabs: [TabItem]
    @Binding var selectedIndex: Int
        
    @State private var hoveringIndex: Int? = nil
    @Namespace private var namespace
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<tabs.count, id: \.self) { index in
                let tab = tabs[index]
                
                Button(action: {
                    withAnimation(.smooth(extraBounce: 0.2)) {
                        selectedIndex = index
                    }
                }) {
                    VStack(spacing: 4) {
                        if let customImageName = tab.customImageName {
                            Image(customImageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .scaleEffect(selectedIndex == index ? 1.1 : 1.0)
                        } else if let systemImageName = tab.systemImageName {
                            Image(systemName: systemImageName)
                                .font(.system(size: 18, weight: .medium))
                                .scaleEffect(selectedIndex == index ? 1.1 : 1.0)
                        }
                        
                        Text(tab.label)
                            .font(.callout)
                            .lineLimit(1)
                    }
                    .foregroundColor(selectedIndex == index ? .app : .primary)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(
                        background(index: index)
                    )
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .onHover { hovering in
                    hoveringIndex = hovering ? index : nil
                }
            }
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 10)            
            .fill(Color.gray.opacity(0.1))
        )
    }
    
    private func background(index: Int) -> some View {
        ZStack {
            if selectedIndex == index {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.app.opacity(0.1))
                    .matchedGeometryEffect(id: "background", in: namespace)
            }
            else if hoveringIndex == index {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.1))
            }
        }
    }
}
