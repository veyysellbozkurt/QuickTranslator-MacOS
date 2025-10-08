//
//  Logger.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 8.10.2025.
//

import Foundation

final class Logger {
    
    // MARK: - Logging Levels
    enum Level: String {
        case info = "[ℹ️ INFO]"
        case warning = "[⚠️ WARNING]"
        case error = "[❌ ERROR]"
        case debug = "[⚡️ DEBUG]"
    }
    
    // MARK: - Main log method
    static func log(_ message: String, level: Level = .info) {
#if DEBUG
        print("\(level.rawValue) \t -- \(message)")
#endif
    }
    
    // MARK: - Convenience methods
    static func info(_ message: String) {
        log(message, level: .info)
    }
    
    static func warning(_ message: String) {
        log(message, level: .warning)
    }
    
    static func error(_ message: String) {
        log(message, level: .error)
    }
    
    static func debug(_ message: String) {
        log(message, level: .debug)
    }
}
