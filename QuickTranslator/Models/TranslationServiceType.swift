//
//  TranslationServiceType.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 10.10.2025.
//

import Foundation

enum TranslationServiceType: String, Codable, CaseIterable {
    case apple
    case google
    
    var title: String {
        switch self {
        case .apple: return "Apple Translate"
        case .google: return "Google Translate"
        }
    }
    var subtitle: String {
        switch self {
        case .apple: return "Offline support — limited languages"
        case .google: return "Online — full language coverage"
        }
    }
    var systemImage: String {
        switch self {
        case .apple: return "applelogo"
        case .google: return "globe"
        }
    }
}
