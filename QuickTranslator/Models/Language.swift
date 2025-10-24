//
//  Language.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 22.08.2025.
//

enum Language: String, CaseIterable {
    case albanian
    case arabic
    case azerbaijani
    case basque
    case bosnian
    case bulgarian
    case catalan
    case chineseSimplified
    case chineseTraditional
    case croatian
    case danish
    case dutch
    case englishGB
    case englishUS
    case finnish
    case frenchCA
    case frenchFR
    case german
    case greek
    case hebrew
    case hindi
    case hungarian
    case indonesian
    case italian
    case japanese
    case korean
    case malay
    case malta
    case norwegian
    case persian
    case polish
    case portugueseBR
    case romanian
    case russian
    case serbian
    case slovak
    case slovene
    case spanishES
    case spanishMX
    case swahili
    case swedish
    case tagalog
    case thai
    case turkish
    case ukrainian
    case vietnamese

    var code: String {
        switch self {
        case .englishUS: return "en-US"
        case .englishGB: return "en-GB"
        case .spanishES: return "es-ES"
        case .spanishMX: return "es-MX"
        case .frenchFR: return "fr-FR"
        case .frenchCA: return "fr-CA"
        case .german: return "de-DE"
        case .italian: return "it-IT"
        case .japanese: return "ja-JP"
        case .russian: return "ru-RU"
        case .chineseSimplified: return "zh-CN"
        case .chineseTraditional: return "zh-TW"
        case .korean: return "ko-KR"
        case .portugueseBR: return "pt-BR"
        case .arabic: return "ar-SA"
        case .turkish: return "tr-TR"
        case .azerbaijani: return "az"
        case .dutch: return "nl"
        case .hindi: return "hi-IN"
        case .indonesian: return "id-ID"
        case .polish: return "pl-PL"
        case .ukrainian: return "uk-UA"
        case .vietnamese: return "vi-VN"
        case .thai: return "th-TH"
        case .finnish: return "fi-FI"
        case .danish: return "da-DK"
        case .norwegian: return "nb-NO"
        case .hungarian: return "hu-HU"
        case .romanian: return "ro-RO"
        case .bulgarian: return "bg-BG"
        case .slovak: return "sk-SK"
        case .slovene: return "sl-SI"
        case .croatian: return "hr-HR"
        case .serbian: return "sr-RS"
        case .malta: return "mt-MT"
        case .hebrew: return "he-IL"
        case .persian: return "fa-IR"
        case .malay: return "ms-MY"
        case .tagalog: return "tl-PH"
        case .catalan: return "ca-ES"
        case .basque: return "eu-ES"
        case .swedish: return "sv-SE"
        case .greek: return "el-GR"
        case .albanian: return "sq-AL"
        case .bosnian: return "bs-BA"
        case .swahili: return "sw-KE"
        }
    }

    var title: String {
        switch self {
        case .englishUS: return "🇺🇸  English (US)"
        case .englishGB: return "🇬🇧  English (UK)"
        case .spanishES: return "🇪🇸  Español (España)"
        case .spanishMX: return "🇲🇽  Español (México)"
        case .frenchFR: return "🇫🇷  Français (France)"
        case .frenchCA: return "🇨🇦  Français (Canada)"
        case .german: return "🇩🇪  Deutsch"
        case .italian: return "🇮🇹  Italiano"
        case .japanese: return "🇯🇵  日本語"
        case .russian: return "🇷🇺  Русский"
        case .chineseSimplified: return "🇨🇳  简体中文"
        case .chineseTraditional: return "🇹🇼  繁體中文"
        case .korean: return "🇰🇷  한국어"
        case .portugueseBR: return "🇧🇷  Português (Brasil)"
        case .arabic: return "🇸🇦  العربية"
        case .turkish: return "🇹🇷  Türkçe"
        case .azerbaijani: return "🇦🇿  Azərbaycan dili"
        case .dutch: return "🇳🇱  Nederlands"
        case .hindi: return "🇮🇳  हिन्दी"
        case .indonesian: return "🇮🇩  Bahasa Indonesia"
        case .polish: return "🇵🇱  Polski"
        case .ukrainian: return "🇺🇦  Українська"
        case .vietnamese: return "🇻🇳  Tiếng Việt"
        case .thai: return "🇹🇭  ภาษาไทย"
        case .finnish: return "🇫🇮  Suomi"
        case .danish: return "🇩🇰  Dansk"
        case .norwegian: return "🇳🇴  Norsk"
        case .hungarian: return "🇭🇺  Magyar"
        case .romanian: return "🇷🇴  Română"
        case .bulgarian: return "🇧🇬  Български"
        case .slovak: return "🇸🇰  Slovenčina"
        case .slovene: return "🇸🇮  Slovenščina"
        case .croatian: return "🇭🇷  Hrvatski"
        case .serbian: return "🇷🇸  Српски"
        case .malta: return "🇲🇹  Malti"
        case .hebrew: return "🇮🇱  עברית"
        case .persian: return "🇮🇷  فارسی"
        case .malay: return "🇲🇾  Bahasa Melayu"
        case .tagalog: return "🇵🇭  Tagalog"
        case .catalan: return "🇪🇸  Català"
        case .basque: return "🇪🇸  Euskara"
        case .swedish: return "🇸🇪  Svenska"
        case .greek: return "🇬🇷  Ελληνικά"
        case .albanian: return "🇦🇱  Shqip"
        case .bosnian: return "🇧🇦  Bosanski"
        case .swahili: return "🇰🇪  Kiswahili"
        }
    }

    
    static var availableLanguages: [Language] {
        guard FeatureManager.shared.translationService == .apple else {
            return Language.allCases
        }
        
        return [
            .arabic,
            .chineseSimplified,
            .chineseTraditional,
            .dutch,
            .englishUS,
            .englishGB,
            .frenchFR,
            .german,
            .hindi,
            .indonesian,
            .italian,
            .japanese,
            .korean,
            .polish,
            .portugueseBR,
            .russian,
            .spanishES,
            .thai,
            .turkish,
            .ukrainian,
            .vietnamese
        ]
    }
}
