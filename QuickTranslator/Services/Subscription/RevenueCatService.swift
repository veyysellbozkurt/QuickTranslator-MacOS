//
//  RevenueCatService.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 28.10.2025.
//

import RevenueCat

final class RevenueCatService {
    
    public var availablePlans: [SubscriptionPlan] = []
    public var selectedPlan: SubscriptionPlan?
    
//    func getSubscriptionPlans() -> [SubscriptionPlan] {
//        
//    }
//    
//    func isPurchased(plan: SubscriptionPlan) -> Bool {
//        
//    }
//    
//    func getPurchases() -> [SubscriptionPlan] {
//        
//    }
    
    func restorePurchases() {
        
    }
    
    func makePurchase() {
        
    }
}

private extension RevenueCatService {
     func convertPackageToSubscriptionPlan(_ package: Package) -> SubscriptionPlan? {
            let product = package.storeProduct
            
            // Determine period based on subscription period
            let period: SubscriptionPlan.SubscriptionPeriod
            if let subscriptionPeriod = product.subscriptionPeriod {
                switch subscriptionPeriod.unit {
                case .day:
                    if subscriptionPeriod.value == 7 {
                        period = .weekly
                    } else {
                        period = .weekly // Default for other day periods
                    }
                case .week:
                    period = .weekly
                case .month:
                    period = subscriptionPeriod.value == 12 ? .yearly : .weekly
                case .year:
                    period = .yearly
                @unknown default:
                    period = .weekly
                }
            } else {
                period = .weekly // Default fallback
            }
            
            // Check for introductory offer (free trial)
            let hasFreeTrial = product.introductoryDiscount != nil
            let freeTrialPeriod = product.introductoryDiscount?.subscriptionPeriod.localizedDescription
            
            return SubscriptionPlan(
                id: product.productIdentifier,
                title: package.localizedPriceString,
                description: product.localizedDescription,
                price: product.localizedPriceString,
                period: period,
                hasFreeTrial: hasFreeTrial,
                freeTrialPeriod: freeTrialPeriod
            )
        }
}
