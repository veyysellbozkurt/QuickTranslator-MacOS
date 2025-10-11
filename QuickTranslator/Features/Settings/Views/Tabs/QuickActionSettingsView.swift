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
    @State private var showVideoPopover = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            SettingsSection(title: "Quick Action") {
                VStack(alignment: .leading, spacing: 16) {
                    
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            DIContainer.shared.settingsWindowManager.updateWindowSize(animated: false)
                        }
                    }
                    
                    Button {
                        showVideoPopover.toggle()
                    } label: {
                        Label("Show Preview Video", systemImage: "play.circle.fill")
                    }
                    .buttonStyle(.borderedProminent)
                    .foregroundStyle(.app.opacity(0.8))
                    .popover(isPresented: $showVideoPopover) {
                        VideoPopoverView(player: player, selectedAction: selectedAction)
                            .frame(width: 400, height: 250)
                            .padding()
                    }
                }
            }
            
            SettingsSection(title: "Time Interval") {
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
            case .directPopover: videoName = "FloatingIconDemo"
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

struct VideoPopoverView: View {
    let player: AVPlayer?
    let selectedAction: QuickActionType

    var body: some View {
        VStack(spacing: 16) {
            Text(selectedAction.displayName)
                .font(.headline)
            if let player {
                VideoPlayer(player: player)
                    .cornerRadius(12)
                    .onAppear {
                        player.seek(to: .zero)
                        player.play()
                    }
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        VStack(spacing: 8) {
                            Image(systemName: "play.rectangle.fill")
                                .font(.system(size: 36))
                                .foregroundStyle(.secondary)
                            Text("Preview not available")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    )
            }
        }
        .padding()
    }
}
