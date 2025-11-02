//
//  AppSessionManager.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 3.11.2025.
//

import Foundation

@MainActor
final class AppSessionManager: ObservableObject {
    static let shared = AppSessionManager()
    
    @Published private(set) var installDateString: String
    @Published private(set) var daysSinceInstall: Int = 0
        
    private init() {
        let defaults = UserDefaults.standard
                
        if let storedString = defaults.string(forKey: .firstAppLaunchDate),
           let storedDate = Date.fromString(storedString) {
            installDateString = storedString
            updateDaysSinceInstall(from: storedDate)
        } else {
            let today = Date()
            let dateStr = today.toString()
            defaults.set(dateStr, forKey: .firstAppLaunchDate)
            installDateString = dateStr
            daysSinceInstall = 0
        }
    }
    
    private func updateDaysSinceInstall(from date: Date) {
        let days = Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
        daysSinceInstall = max(days, 0)
    }
    
    func updateDaysSinceInstall() {
        if let date = Date.fromString(installDateString) {
            updateDaysSinceInstall(from: date)
        }
    }
    
    func resetInstallDate(to date: Date = Date()) {
        let dateStr = date.toString()
        UserDefaults.standard.set(dateStr, forKey: .firstAppLaunchDate)
        installDateString = dateStr
        updateDaysSinceInstall(from: date)
    }
}
