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
    @State private var floatingIconVisibilityDuration: Double = FeatureManager.shared.floatingIconVisibilityDuration
    
    @State private var player: AVPlayer? = nil
    @State private var showVideo = false
    @State private var showVideoPopover = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SettingsSection(title: "Quick Action") {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // MARK: - Picker
                    Text("Choose what happens when you double press ⌘ + C:")
                        .font(.caption2)
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
                    
                    Button {
                        showVideoPopover.toggle()
                    } label: {
                        Label("Show Preview", systemImage: "play.circle.fill")
                    }
                    .buttonStyle(.borderedProminent)
                    .foregroundStyle(.app.opacity(0.5))
                    .popover(isPresented: $showVideoPopover) {
                        VideoPopoverView(player: player, selectedAction: selectedAction)
                            .frame(width: 400, height: 250)
                            .padding()
                    }
                }
            }
            
            SettingsSection(title: "Time Interval") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Floating Icon Visibility Duration: \(String(format: "%.1f", floatingIconVisibilityDuration))s")
                        .fontWeight(.medium)
                    
                    Slider(value: $floatingIconVisibilityDuration, in: 1...5, step: 1)
                        .tint(.app)
                        .onChange(of: floatingIconVisibilityDuration) {
                            featureManager.floatingIconVisibilityDuration = floatingIconVisibilityDuration
                        }
                    
                    Text("Set how long the floating icon remains visible after a double key press before it automatically hides.")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(width: 350)
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
