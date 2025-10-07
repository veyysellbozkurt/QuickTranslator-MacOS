//
//  Constants.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 27.08.2025.
//

import Foundation

enum Constants {
    enum Strings {
        static let inputPlaceholder = "Enter text and start to translate by pressing Enter ↩︎.\nControl + Enter to start a new line"
        static let outputPlaceholder = "Translated text is here..."
        static let translateButton = "Translate"
        static let translating = "Translating..."
        static let quit = "Quit"
        
        static let cancel = "Cancel"
        static let openSettings = "Open Settings"
        static let accessibilityTitle = "Accessibility Permission Needed"
        static let accessibilityMessage = """
                        QuickTranslator needs permission to monitor your keyboard shortcuts (like double ⌘ C) so it can instantly translate copied text.
                            
                            Please enable QuickTranslator under:
                            System Settings → Privacy & Security → Accessibility
    """
    }
    
    enum Urls {
        static let buyMeCoffee = URL(string: "https://buymeacoffee.com/veyselbozkurt")!
        static let accessibilitySettingsURL = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")
    }
}
