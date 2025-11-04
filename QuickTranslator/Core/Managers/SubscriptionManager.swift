//
//  SubscriptionManager.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 28.10.2025.
//

import SwiftUI
import RevenueCat

@MainActor
final class SubscriptionManager: ObservableObject {
    
    static let shared = SubscriptionManager()
    
    @Published private(set) var isSubscribed: Bool = false
    @Published private(set) var lastRestoreDate: Date = .distantPast
    @Published private(set) var packages: [Package] = []
    
    private let service = RevenueCatService()
    private let userDefaults = UserDefaults.standard
    
    private init() {
        loadLastRestoreDate()
    }
    
    func configure() {
        service.configure()
    }
    
    func checkSubscriptionStatusIfNeeded() async {
        guard !isDateInToday(lastRestoreDate) else { return }
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
        
    func fetchPackages() async {
        let result = await service.fetchPackages()
        switch result {
        case .success(let fetchedPackages):
            packages = fetchedPackages
            print("✅ \(packages.count) paket bulundu.")
        case .failure:
            print("⚠️ Paketler alınamadı.")
            packages = []
        }
    }
}

private extension SubscriptionManager {
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
    
    func isDateInToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
}
