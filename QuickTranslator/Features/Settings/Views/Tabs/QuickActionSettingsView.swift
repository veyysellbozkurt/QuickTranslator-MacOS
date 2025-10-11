//
//  QuickActionSettingsView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 6.10.2025.
//

import SwiftUI
import AVKit

struct QuickActionSettingsView: View {
    @ObservedObject private var featureManager = FeatureManager.shared
    @State private var selectedAction: QuickActionType = FeatureManager.shared.quickActionType
    @State private var doubleKeyInterval: Double = FeatureManager.shared.doubleKeyInterval
    
    @State private var player: AVPlayer? = nil
    @State private var showVideo = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            SettingsSection(title: "Quick Action") {
                VStack(alignment: .leading, spacing: 12) {
                    
                    // MARK: - Picker
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
                        playVideo(for: selectedAction)
                    }
                    
                    // MARK: - Video Preview
                    if let player = player, showVideo {
                        VideoPlayer(player: player)
                            .frame(height: 120)
                            .cornerRadius(10)
                            .transition(.opacity.combined(with: .scale))
                            .onAppear {
                                player.seek(to: .zero)
                                player.play()
                            }
                    }
                    
                    // MARK: - Time Interval
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Double Key Interval: \(String(format: "%.1f", doubleKeyInterval))s")
                        
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
        .animation(.easeInOut(duration: 0.25), value: showVideo)
        .onAppear {
            playVideo(for: selectedAction)
        }
    }
    
    // MARK: - Video Selection Logic
    private func playVideo(for action: QuickActionType) {
        let videoName: String
        switch action {
            case .directPopover: videoName = "QuickActionDemo"
            case .floatingIconPopover:    videoName = "FloatingIconDemo"
        }
        
        if let url = Bundle.main.url(forResource: videoName, withExtension: "mov") {
            player = AVPlayer(url: url)
            showVideo = true
        } else {
            showVideo = false
            player = nil
        }
    }
}
