//
//  SettingsSection.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 27.10.2025.
//

import SwiftUI

struct SettingsSection<Content: View>: View {
    let title: String
    let footnote: String?
    let content: () -> Content
    
    init(title: String, footnote: String? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.footnote = footnote
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title.uppercased())
                .font(.appFont(.semibold, size: 11))
                .foregroundStyle(.textSecondary)
            
            VStack(alignment: .leading, spacing: 12) {
                content()
                if let footnote = footnote {
                    Text(footnote)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                        .font(.appCaption())
                        .foregroundStyle(.textSecondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.08))
                    .strokeBorder(.gray.opacity(0.1), lineWidth: 2)
            )
        }
    }
}
