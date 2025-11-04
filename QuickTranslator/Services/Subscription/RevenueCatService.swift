//
//  RevenueCatService.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 28.10.2025.
//

import RevenueCat

enum RevenueCatError: Error {
    case fetchFailed
    case restoreFailed
}

final class RevenueCatService {
    
    func configure() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: Constants.Keys.revenueCatAPIKey)
    }
    
    func fetchSubscriptionStatus() async -> Result<Bool, RevenueCatError> {
        do {
            let info = try await Purchases.shared.customerInfo()
            let isSubscribed = info.entitlements.active[Constants.Subscription.entitlementID] != nil
            return .success(isSubscribed)
        } catch {
            print("⚠️ Fetch failed:", error.localizedDescription)
            return .failure(.fetchFailed)
        }
    }
    
    func restorePurchases() async -> Result<Bool, RevenueCatError> {
        do {
            let info = try await Purchases.shared.restorePurchases()
            let isSubscribed = info.entitlements.active[Constants.Subscription.entitlementID] != nil
            return .success(isSubscribed)
        } catch {
            print("⚠️ Restore failed:", error.localizedDescription)
            return .failure(.restoreFailed)
        }
    }
    
    func fetchPackages() async -> Result<[Package], RevenueCatError> {
        do {
            let offerings = try await Purchases.shared.offerings()
            
            guard let availablePackages = offerings.current?.availablePackages, !availablePackages.isEmpty else {
                print("⚠️ No packages found in current offering.")
                return .failure(.fetchFailed)
            }
            
            return .success(availablePackages)
        } catch {
            print("⚠️ Failed to fetch offerings:", error.localizedDescription)
            return .failure(.fetchFailed)
        }
    }
}
