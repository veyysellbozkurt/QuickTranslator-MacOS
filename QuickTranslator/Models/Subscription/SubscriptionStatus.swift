//
//  SubscriptionStatus.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 28.10.2025.
//

import Foundation

public enum SubscriptionStatus {
    case active(expirationDate: Date?)
    case inactive
    case unknown
    
    public var isActive: Bool {
        switch self {
        case .active:
            return true
        case .inactive, .unknown:
            return false
        }
    }
}
