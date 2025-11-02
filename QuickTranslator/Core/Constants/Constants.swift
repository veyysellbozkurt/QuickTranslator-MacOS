//
//  Constants.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 27.08.2025.
//

import Foundation
import AppKit

enum Constants {
    
    enum Strings {
        // General & Translation Strings
        static let inputPlaceholder = "Press `enter` to translate"
        static let outputPlaceholder = "Your translation will appear here..."
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
        
        // --- General Settings ---
        static let launchSettingsTitle = "Launch Settings"
        static let launchOnStartup = "Launch on system startup"
        static let launchOnStartupDescription = "The app will automatically start when you log in to your Mac."
        static let inputLayoutTitle = "Input Layout"
        static let menuBarIconTitle = "Menu Bar Icon"
        static let menuBarIconDescription = "You need to restart the app for the changes to take effect."
        
        // --- Translation Settings ---
        static let translationEngineTitle = "Translation Engine"
        static let translationEngineDescription = "Pick an engine. Apple works offline for some languages; Google provides the broadest online coverage."
        static let appleTranslateTitle = "Apple Translate"
        static let appleOfflineModeEnabled = "Offline Mode Enabled"
        static let appleOfflineMessage = "You can download languages for offline use via System Settings."
        static let appleStep1 = "Open System Settings → General"
        static let appleStep2 = "Choose Language & Region"
        static let appleStep3 = "Open Translation Languages and download desired languages"
        static let appleSupportedLanguagesMessage = "Apple supports approximately %d languages for offline translation."
        static let googleTranslateTitle = "Google Translate"
        static let googleUnlimitedSupportTitle = "Unlimited Language Support"
        static let googleUnlimitedSupportMessage = "Uses online APIs for broad language coverage. Requires network access."
        
        // --- Quick Action Settings ---
        static let quickActionTitle = "Quick Action"
        static let quickActionPickerDescription = "Choose what happens when you double press ⌘ + C:"
        static let showPreviewButton = "Show Preview"
        static let timeIntervalTitle = "Time Interval"
        static let floatingIconVisibility = "Floating Icon Visibility Duration: %.1fs"
        static let floatingIconDescription = "Set how long the floating icon remains visible after a double key press before it automatically hides."
        static let previewNotAvailable = "Preview not available"
        
        // --- About Settings ---
        static let aboutAppDescription = "A fast and efficient translation tool for macOS."
        static let versionPrefix = "Version %@"
        static let rateButtonTitle = "Rate on the App Store"
        static let rateButtonHelp = "Open the App Store review page"
        static let feedbackButtonTitle = "Send Feedback"
        static let feedbackButtonHelp = "Send feedback via email"
        static let enjoyAppTitle = "Enjoying %@?"
        static let enjoyAppDescription = "Your rating helps others discover the app and supports future improvements."
    }
    
    enum Urls {
        static let buyMeCoffee = URL(string: "https://buymeacoffee.com/veyselbozkurt")!
        static let accessibilitySettingsURL = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")
        static let appStoreReviewURL = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID?action=write-review")
    }
    
    enum Keys {
        static let revenueCatAPIKey = "appl_mmneBSXjoetGxSZexFRgmnQUmES"
    }
    
    enum Subscription {
        static let entitlementID = ""
    }
    
    static var appName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Quick Translator"
    }
    
    static var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
    }
}
