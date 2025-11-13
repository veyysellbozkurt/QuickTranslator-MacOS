//
//  String+Ext.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 13.11.2025.
//

import Foundation

extension String {
    func isPureURL() -> Bool {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.contains(" ") { return false }
        
        if let url = URL(string: trimmed),
           let scheme = url.scheme, ["http", "https"].contains(scheme.lowercased()) {
            return true
        }
                
        let domainRegex = #"^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        if trimmed.range(of: domainRegex, options: .regularExpression) != nil {
            return true
        }
        
        return false
    }
}
