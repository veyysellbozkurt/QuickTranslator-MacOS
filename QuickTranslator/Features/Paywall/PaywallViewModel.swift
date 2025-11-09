//
//  PaywallViewModel.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 4.11.2025.
//

import SwiftUI
import RevenueCat

@MainActor
final class PaywallViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published private(set) var packages: [Package] = []
    @Published var items: [PricingItem] = []

    // MARK: - Pricing Item Model
    struct PricingItem: Identifiable, Equatable {
        let id: String
        let title: String
        let subtitle: String
        let priceText: String
        let periodText: String
        let monthlyEquivalentText: String?
        let discountText: String?
        let package: Package?
    }

    // MARK: - Public API
    func loadPackages() async {
        showLoading()
        defer { hideLoading() }

        await SubscriptionManager.shared.fetchPackages()
        packages = SubscriptionManager.shared.packages

        guard !packages.isEmpty else {
            items = []
            return
        }

        items = mapPackagesToPricingItems(packages)
    }

    // MARK: - Package Mapping
    private func mapPackagesToPricingItems(_ packages: [Package]) -> [PricingItem] {
        let monthlyPackage = findPackage(containing: ["month"], in: packages)
        let yearlyPackage = findPackage(containing: ["year", "annual"], in: packages)

        let discountText = calculateDiscountText(monthlyPackage: monthlyPackage, yearlyPackage: yearlyPackage)

        return packages.map { package in
            let product = package.storeProduct
            let isYearly = product.productIdentifier.lowercased().contains("year") || product.productIdentifier.lowercased().contains("annual")

            return PricingItem(
                id: package.identifier,
                title: title(for: product),
                subtitle: introTrialText(for: product),
                priceText: product.localizedPriceString,
                periodText: periodText(for: product),
                monthlyEquivalentText: isYearly ? monthlyEquivalentText(for: product) : nil,
                discountText: isYearly ? discountText : nil,
                package: package
            )
        }
    }

    // MARK: - Package Helpers
    private func findPackage(containing keywords: [String], in packages: [Package]) -> Package? {
        packages.first { package in
            let id = package.storeProduct.productIdentifier.lowercased()
            return keywords.contains { id.contains($0) }
        }
    }

    private func calculateDiscountText(monthlyPackage: Package?, yearlyPackage: Package?) -> String? {
        guard
            let monthlyPrice = (monthlyPackage?.storeProduct.price as NSDecimalNumber?)?.doubleValue,
            let yearlyPrice = (yearlyPackage?.storeProduct.price as NSDecimalNumber?)?.doubleValue
        else {
            return nil
        }

        let fullYearCost = monthlyPrice * 12
        let discountRatio = 1 - (yearlyPrice / fullYearCost)
        guard discountRatio > 0 else { return nil }

        return String(format: "%.0f%% Off", discountRatio * 100)
    }

    private func monthlyEquivalentText(for product: StoreProduct) -> String {
        let monthly = (product.price as NSDecimalNumber).doubleValue / 12.0
        if let formatter = product.priceFormatter {
            let monthlyNumber = NSNumber(value: monthly)
            if let formatted = formatter.string(from: monthlyNumber) {
                return "\(formatted) / Month"
            }
        }
        // If formatter is nil, use currency code before price
        let currency = product.currencyCode ?? ""
        return "\(currency) \(String(format: "%.2f", monthly)) / Month"
    }

    // MARK: - Text Builders
    private func title(for product: StoreProduct) -> String {
        let id = product.productIdentifier.lowercased()
        if id.contains("year") || id.contains("annual") {
            return "Yearly Plan"
        } else if id.contains("month") {
            return "Monthly Plan"
        } else {
            return "Subscription Plan"
        }
    }

    private func introTrialText(for product: StoreProduct) -> String {
        guard let intro = product.introductoryDiscount else { return "" }
        let period = intro.subscriptionPeriod
        let unitText: String
        switch period.unit {
        case .day: unitText = "day"
        case .week: unitText = "week"
        case .month: unitText = "month"
        case .year: unitText = "year"
        @unknown default: unitText = ""
        }
        return "\(period.value) \(unitText) free trial"
    }

    private func periodText(for product: StoreProduct) -> String {
        guard let period = product.subscriptionPeriod else { return "" }
        switch period.unit {
        case .month: return "/ Month"
        case .year: return "/ Year"
        case .week: return "/ Week"
        case .day: return "/ Day"
        @unknown default: return ""
        }
    }

    // MARK: - Loading State
    func showLoading() {
        withAnimation { isLoading = true }
    }

    func hideLoading() {
        withAnimation { isLoading = false }
    }
}
