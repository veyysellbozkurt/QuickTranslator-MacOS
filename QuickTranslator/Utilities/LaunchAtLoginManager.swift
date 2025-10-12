//
//  LaunchAtLoginManager.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 12.10.2025.
//

import ServiceManagement

@MainActor
final class LaunchAtLoginManager: ObservableObject {
    @Published var isEnabled: Bool = false

    private let service = SMAppService.mainApp

    init() {
        updateStatus()
    }

    func updateStatus() {
        isEnabled = (service.status == .enabled)
    }

    func toggleLaunchAtLogin() {
        do {
            if isEnabled {
                try service.unregister()
            } else {
                try service.register()
            }
            updateStatus()
        } catch {
            print("Launch at login toggle failed: \(error.localizedDescription)")
        }
    }
}
