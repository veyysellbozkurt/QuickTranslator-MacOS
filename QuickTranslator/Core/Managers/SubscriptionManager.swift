//
//  SubscriptionManager.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 28.10.2025.
//

import RevenueCat

final class SubscriptionManager {
    
    func configure() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: Constants.Keys.revenueCatAPIKey)        
    }
    
}
