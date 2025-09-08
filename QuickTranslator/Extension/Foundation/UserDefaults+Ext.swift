//
//  UserDefaults+Ext.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 26.08.2025.
//

import Foundation

let Storage = UserDefaults.standard

extension UserDefaults {
    enum Key: String {
        case sourceLanguage
        case targetLanguage
        case quickActionTranslationType
    }
    
    // MARK: - Set -
    func set(_ value: Any?, forKey key: Key) {
        set(value, forKey: key.rawValue)
    }
    
    func set(_ value: Bool, forKey key: Key) {
        set(value, forKey: key.rawValue)
    }
    
    func set(_ value: Int, forKey key: Key) {
        set(value, forKey: key.rawValue)
    }
    
    func set(_ value: String, forKey key: Key) {
        set(value, forKey: key.rawValue)
    }
    
    func set<T: Encodable>(encodable: T, forKey key: Key) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key.rawValue)
        }
    }
    //    MARK: - Get
    func int(forKey key: Key) -> Int {
        return integer(forKey: key.rawValue)
    }
    
    func bool(forKey key: Key) -> Bool {
        return bool(forKey: key.rawValue)
    }
    
    func string(forKey key: Key) -> String? {
        return string(forKey: key.rawValue)
    }
    
    func value(forKey key: Key) -> Any? {
        return value(forKey: key.rawValue)
    }
    
    func value<T: Decodable>(_ type: T.Type, forKey key: Key) -> T? {
        if let data = object(forKey: key.rawValue) as? Data,
           let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
    
    // MARK: - Delete -
    func removeObject(forKey key: Key) {
        removeObject(forKey: key.rawValue)
    }
}
