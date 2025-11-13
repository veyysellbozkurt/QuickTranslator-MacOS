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
        VStack(alignment: .leading, spacing: 20) {
            SettingsSection(title: Constants.Strings.quickActionTitle,
                            footnote: Constants.Strings.quickActionPickerDescription) {
                VStack(alignment: .leading, spacing: 16) {
                    
                    CompactSegmentedPicker(
                        options: QuickActionType.allCases,
                        selection: $selectedAction,
                        iconProvider: \.iconName,
                        titleProvider: \.displayName
                    )
                    .onChange(of: selectedAction) {
                        featureManager.quickActionType = selectedAction
                    }
                    
                    HStack(spacing: 12) {
                        Button {
                            showVideoPopover.toggle()
                        } label: {
                            Label(Constants.Strings.showPreviewButton, systemImage: "play.circle.fill")
                                .font(.appSmallTitle())
                        }
                        .buttonStyle(.bordered)
                        .popover(isPresented: $showVideoPopover) {
                            VideoPopoverView(player: player)
                                .frame(width: 700, height: 450)
                        }

                        if !DoubleKeyMonitor.isAccessibilityPermissionGranted() {
                            Button {
                                DoubleKeyMonitor.showAccessibilityPermissionAlert()
                            } label: {
                                Label("Enable Accessibility", systemImage: "hand.raised.fill")
                                    .font(.appSmallTitle())
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }
            }
            
            SettingsSection(title: Constants.Strings.timeIntervalTitle,
                            footnote: Constants.Strings.floatingIconDescription) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(String(format: Constants.Strings.floatingIconVisibility, floatingIconVisibilityDuration))
                        .font(.appSmallTitle())
                        .foregroundStyle(.textPrimary)
                    
                    Slider(value: $floatingIconVisibilityDuration, in: 1...5, step: 1)
                        .tint(.app)
                        .onChange(of: floatingIconVisibilityDuration) {
                            featureManager.floatingIconVisibilityDuration = floatingIconVisibilityDuration
                        }
                }
                .frame(width: 350)
            }
        }
        .onAppear {
            playVideo()
        }
        .frame(height: 280)
        .animation(.easeInOut(duration: 0.25), value: showVideo)
    }
    
    // MARK: - Video Selection Logic
    private func playVideo() {
        if let url = Bundle.main.url(forResource: "QuickActionPreview", withExtension: "mp4") {
            DispatchQueue.main.async {
                player = AVPlayer(url: url)
                showVideo = true
            }
        } else {
            DispatchQueue.main.async {
                showVideo = false
                player = nil
            }
        }
    }
}

struct VideoPopoverView: View {
    let player: AVPlayer?

    var body: some View {
        VStack(spacing: 8) {
            Text("Video Preview")
                .font(.appSmallTitle13())
            if let player {
                                
                VideoPlayer(player: player)
                    .cornerRadius(12)
                    .onAppear {
                        player.seek(to: .zero)
                        player.play()
                        player.rate = 0.5
                    }
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        VStack(spacing: 8) {
                            Image(systemName: "play.rectangle.fill")
                                .font(.system(size: 36))
                                .foregroundStyle(.textSecondary)
                            Text(Constants.Strings.previewNotAvailable)
                                .font(.appCaption())
                                .foregroundStyle(.textSecondary)
                        }
                    )
            }
        }
        .padding(12)
    }
}
