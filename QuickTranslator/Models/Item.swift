//
//  Item.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 18.08.2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
