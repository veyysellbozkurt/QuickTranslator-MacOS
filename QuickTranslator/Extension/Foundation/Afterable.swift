//
//  Afterable.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 17.09.2025.
//

import Foundation

protocol Afterable {
    func perform(_ callback: @escaping EmptyCallback)
    func performShortAfter(_ callback: @escaping EmptyCallback)
    func performAfter(_ delay: Double, _ callback: @escaping EmptyCallback)
}

extension Afterable {
    /// Performs the task in the main thread without delay
    func perform(_ callback: @escaping EmptyCallback) {
        DispatchQueue.main.async {
            callback()
        }
    }
    
    /// Performs the task in the main thread with `0.1` second delay
    func performShortAfter(_ callback: @escaping EmptyCallback) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            callback()
        }
    }
    
    /// Performs the task in the main thread
    func performAfter(_ delay: Double, _ callback: @escaping EmptyCallback) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            callback()
        }
    }
}
