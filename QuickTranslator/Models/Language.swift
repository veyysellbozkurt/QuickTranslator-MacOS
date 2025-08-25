//
//  Language.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 22.08.2025.
//

enum Language: String, CaseIterable {
    case english
    case turkish
    case french
    case spanish
    case italian
    case german
    case dutch
    case russian
    case japanese
    case chinese

    var code: String {
        switch self {
        case .english: return "en"
        case .turkish: return "tr"
        case .french:  return "fr"
        case .spanish: return "es"
        case .italian: return "it"
        case .german:  return "de"
        case .dutch:   return "nl"
        case .russian: return "ru"
        case .japanese: return "ja"
        case .chinese: return "zh"
        }
    }
}
