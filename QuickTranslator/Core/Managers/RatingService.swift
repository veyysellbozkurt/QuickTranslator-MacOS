//
//  RatingService.swift
//  QuickTranslator (macOS)
//
//  Created by Veysel Bozkurt on 3.11.2025.
//

import Foundation
import StoreKit
import AppKit

public final class RatingService {
    public static let shared = RatingService()
    
    private let firstRequestAfterDays = 1
    
    private init() {}
    
    @MainActor
    public func requestRatingIfNeeded() {
        guard AppSessionManager.shared.daysSinceInstall >= firstRequestAfterDays else { return }
        
        if let windowController = NSApp.keyWindow?.contentViewController {
            AppStore.requestReview(in: windowController)
        }
    }
    
    public func openAppStoreReview() {
        guard let url = Constants.Urls.appStoreReviewURL else { return }
        NSWorkspace.shared.open(url)
    }
}
