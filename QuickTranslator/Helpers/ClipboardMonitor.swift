//
//  ClipboardMonitor.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 27.08.2025.
//

import AppKit

final class ClipboardMonitor {
    private var timer: Timer?
    private var lastChangeCount = NSPasteboard.general.changeCount
    private var lastString: String?
    var onCopy: ((String) -> Void)?
    
    func start(interval: TimeInterval = 0.5) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { [weak self] _ in
            self?.tick()
        })
        timer?.tolerance = 0.1
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    private func tick() {
        let pasteboard = NSPasteboard.general
        guard pasteboard.changeCount != lastChangeCount else { return }
        lastChangeCount = pasteboard.changeCount
        
        if let copiedString = pasteboard.string(forType: .string)?.trimmingCharacters(in: .whitespacesAndNewlines),
           !copiedString.isEmpty,
           copiedString != lastString,
           copiedString.count >= 3, copiedString.count <= 1000 {
            lastString = copiedString
            onCopy?(copiedString)
        }
    }
}
