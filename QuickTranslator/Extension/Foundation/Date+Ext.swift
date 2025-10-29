//
//  Date+Extensions.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 29.10.2025.
//

import Foundation

extension Date {
    private static let sharedFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    func toString() -> String {
        Self.sharedFormatter.string(from: self)
    }
    
    static func fromString(_ string: String) -> Date? {
        Self.sharedFormatter.date(from: string)
    }
}
