//
//  DailyUsageManager.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 1.11.2025.
//

import Foundation
import Combine

@MainActor
final class DailyUsageManager: ObservableObject {
    
    static let shared = DailyUsageManager()
    
    @Published private(set) var isLimitReached: Bool = false
    private(set) var remainingTranslations: Int = 8
    
    private var lastResetDate: Date = .now
    private let dailyLimit: Int = 8
    private let userDefaults = UserDefaults.standard
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        loadState()
        resetIfNeeded()
        updateLimitState()
        observeSubscription()
    }
    
    // MARK: - Public API
    
    func recordTranslation() {
        if SubscriptionManager.shared.isSubscribed {
            return
        }
        
        guard !isLimitReached else { return }
        
        remainingTranslations -= 1
        updateLimitState()
        saveState()
    }
    
    func resetIfNeeded() {
        guard !SubscriptionManager.shared.isSubscribed else { return }
        
        let calendar = Calendar.current
        if !calendar.isDateInToday(lastResetDate) {
            remainingTranslations = dailyLimit
            lastResetDate = .now
            updateLimitState()
            saveState()
        }
    }
}

// MARK: - Helpers & Persistence
private extension DailyUsageManager {
    
    func updateLimitState() {
        if SubscriptionManager.shared.isSubscribed {
            isLimitReached = false
        } else {
            isLimitReached = remainingTranslations <= 0
        }
    }
    
    func saveState() {
        userDefaults.set(remainingTranslations, forKey: .remainingTranslationsCount)
        userDefaults.set(lastResetDate.toString(), forKey: .lastLimitResetDate)
    }
    
    func loadState() {
        if let savedDateString = userDefaults.string(forKey: .lastLimitResetDate),
           let savedDate = Date.fromString(savedDateString) {
            lastResetDate = savedDate
        }
        
        let savedCount = userDefaults.int(forKey: .remainingTranslationsCount)
        if savedCount > 0 {
            remainingTranslations = savedCount
        }
    }
    
    func observeSubscription() {
        SubscriptionManager.shared.$isSubscribed
            .sink { [weak self] _ in
                self?.updateLimitState()
            }
            .store(in: &cancellables)
    }
}
