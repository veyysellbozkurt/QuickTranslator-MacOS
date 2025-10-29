//
//  SubscriptionManager.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 28.10.2025.
//

import SwiftUI

@MainActor
final class SubscriptionManager: ObservableObject {
    
    static let shared = SubscriptionManager()
    
    @Published private(set) var isSubscribed: Bool = false
    @Published private(set) var lastRestoreDate: Date = .distantPast
    
    private let service = RevenueCatService()
    private let userDefaults = UserDefaults.standard
    
    private init() {
        loadLastRestoreDate()
    }
    
    func configure() {
        service.configure()
    }
    
    func checkSubscriptionStatusIfNeeded() async {
        guard isTimeToCheck else { return }
        await checkSubscriptionStatus()
    }
    
    func checkSubscriptionStatus() async {
        let result = await service.fetchSubscriptionStatus()
        switch result {
        case .success(let subscribed):
            isSubscribed = subscribed
            saveRestoreDate()
        case .failure:
            break
        }
    }
    
    func restorePurchases() async {
        let result = await service.restorePurchases()
        switch result {
        case .success(let subscribed):
            isSubscribed = subscribed
            saveRestoreDate()
        case .failure:
            break
        }
    }
}

private extension SubscriptionManager {
    var isTimeToCheck: Bool {
        Date().timeIntervalSince(lastRestoreDate) > 24 * 60 * 60
    }
    
    func saveRestoreDate() {
        lastRestoreDate = Date()
        userDefaults.set(lastRestoreDate.toString(), forKey: .lastRestoreDate)
    }

    func loadLastRestoreDate() {
        if let stringDate = userDefaults.string(forKey: .lastRestoreDate),
           let date = Date.fromString(stringDate) {
            lastRestoreDate = date
        }
    }
}
