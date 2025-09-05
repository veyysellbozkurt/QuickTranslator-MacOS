//
//  Language.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 22.08.2025.
//

enum Language: String, CaseIterable {
    case englishUS
    case englishGB
    case spanishES
    case spanishMX
    case frenchFR
    case frenchCA
    case german
    case italian
    case japanese
    case russian
    case chineseSimplified
    case chineseTraditional
    case korean
    case portugueseBR
    case arabic
    case turkish
    case azerbaijani
    case dutch
    case hindi
    case indonesian
    case polish
    case ukrainian
    case vietnamese
    case thai
    case finnish
    case danish
    case norwegian
    case hungarian
    case romanian
    case bulgarian
    case slovak
    case slovene
    case croatian
    case serbian
    case malta
    case hebrew
    case persian
    case malay
    case tagalog
    case catalan
    case basque
    case swedish
    case greek
    case albanian
    case bosnian
    case swahili

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
        case .englishUS: return "🇺🇸 English (US)"
        case .englishGB: return "🇬🇧 English (UK)"
        case .spanishES: return "🇪🇸 Spanish (Spain)"
        case .spanishMX: return "🇲🇽 Spanish (Mexico)"
        case .frenchFR: return "🇫🇷 French (France)"
        case .frenchCA: return "🇨🇦 French (Canada)"
        case .german: return "🇩🇪 German"
        case .italian: return "🇮🇹 Italian"
        case .japanese: return "🇯🇵 Japanese"
        case .russian: return "🇷🇺 Russian"
        case .chineseSimplified: return "🇨🇳 Chinese (Simplified)"
        case .chineseTraditional: return "🇹🇼 Chinese (Traditional)"
        case .korean: return "🇰🇷 Korean"
        case .portugueseBR: return "🇧🇷 Portuguese (Brazil)"
        case .arabic: return "🇸🇦 Arabic"
        case .turkish: return "🇹🇷 Turkish"
        case .azerbaijani: return "🇦🇿 Azerbaijani"
        case .dutch: return "🇳🇱 Dutch"
        case .hindi: return "🇮🇳 Hindi"
        case .indonesian: return "🇮🇩 Indonesian"
        case .polish: return "🇵🇱 Polish"
        case .ukrainian: return "🇺🇦 Ukrainian"
        case .vietnamese: return "🇻🇳 Vietnamese"
        case .thai: return "🇹🇭 Thai"
        case .finnish: return "🇫🇮 Finnish"
        case .danish: return "🇩🇰 Danish"
        case .norwegian: return "🇳🇴 Norwegian"
        case .hungarian: return "🇭🇺 Hungarian"
        case .romanian: return "🇷🇴 Romanian"
        case .bulgarian: return "🇧🇬 Bulgarian"
        case .slovak: return "🇸🇰 Slovak"
        case .slovene: return "🇸🇮 Slovene"
        case .croatian: return "🇭🇷 Croatian"
        case .serbian: return "🇷🇸 Serbian"
        case .malta: return "🇲🇹 Maltese"
        case .hebrew: return "🇮🇱 Hebrew"
        case .persian: return "🇮🇷 Persian"
        case .malay: return "🇲🇾 Malay"
        case .tagalog: return "🇵🇭 Tagalog"
        case .catalan: return "🇪🇸 Catalan"
        case .basque: return "🇪🇸 Basque"
        case .swedish: return "🇸🇪 Swedish"
        case .greek: return "🇬🇷 Greek"
        case .albanian: return "🇦🇱 Albanian"
        case .bosnian: return "🇧🇦 Bosnian"
        case .swahili: return "🇰🇪 Swahili"
        }
    }
}
