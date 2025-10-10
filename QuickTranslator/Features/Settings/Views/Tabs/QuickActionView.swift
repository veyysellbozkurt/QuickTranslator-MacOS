//
//  QuickActionView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 6.10.2025.
//

import SwiftUI

struct QuickActionView: View {
    @ObservedObject private var featureManager = FeatureManager.shared
    @State private var selectedAction: QuickActionType = FeatureManager.shared.quickActionType
    @State private var doubleKeyInterval: Double = FeatureManager.shared.doubleKeyInterval

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            SettingsSection(title: "Quick Action") {
                VStack(alignment: .leading, spacing: 24) {
                    
                    Text("Choose what happens when you double press ⌘ + C:")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    
                    Picker("Action Type", selection: $selectedAction) {
                        ForEach(QuickActionType.allCases, id: \.self) { action in
                            Label(action.displayName, systemImage: action.iconName)
                                .tag(action)
                        }
                    }
                    .pickerStyle(.inline)
                    .tint(.app)
                    .onChange(of: selectedAction) {
                        featureManager.quickActionType = selectedAction
                    }
                                        
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Double Key Interval: \(String(format: "%.1f", doubleKeyInterval))s")
                            Spacer()
                        }
                        Slider(value: $doubleKeyInterval, in: 0.1...5.0, step: 0.1)
                            .tint(.app)
                            .onChange(of: doubleKeyInterval) {
                                featureManager.doubleKeyInterval = doubleKeyInterval
                            }
                        
                        Text("Maximum delay between double ⌘ + C presses. Default is 1.0s")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
    }
}
