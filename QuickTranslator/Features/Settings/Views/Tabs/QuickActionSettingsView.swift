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
                        playVideo(for: selectedAction)
                    }
                    
                    Button {
                        showVideoPopover.toggle()
                    } label: {
                        Label(Constants.Strings.showPreviewButton, systemImage: "play.circle.fill")
                            .font(.appSmallTitle())
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
        .frame(height: 280)
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
            case .floatingIconPopover: videoName = "FloatingIconDemo"
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
                .font(.appSmallTitle())
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
                                .foregroundStyle(.textSecondary)
                            Text(Constants.Strings.previewNotAvailable)
                                .font(.appCaption())
                                .foregroundStyle(.textSecondary)
                        }
                    )
            }
        }
        .padding()
    }
}
