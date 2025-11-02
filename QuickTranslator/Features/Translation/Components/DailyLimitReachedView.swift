//
//  DailyLimitReachedView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 1.11.2025.
//

import SwiftUI
import AppKit

struct DailyLimitReachedView: View {
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "lock.circle.fill")
                .symbolRenderingMode(.hierarchical)
                .font(.system(size: 32))
                .foregroundStyle(.controlYellow)
            
            (Text("You’ve reached your ")
            + Text("daily limit").foregroundColor(.controlRed).bold()
             + Text(" (\(DailyUsageManager.shared.dailyLimit)/\(DailyUsageManager.shared.dailyLimit))"))
                .font(.appSmallTitle13())
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(.hoverBackground.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.textAreaBackground)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Preview
#Preview {
    DailyLimitReachedView()
        .frame(width: 400, height: 300)
}
