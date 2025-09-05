//
//  DoubleKeyMonitor.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 27.08.2025.
//

import AppKit
import Cocoa

final class DoubleKeyMonitor {
    
    private let doubleTapInterval: TimeInterval
    private var lastKeyPress: Date?
    private var eventTap: CFMachPort?
    private let doubleKey: DoubleKey
    
    var onDoublePress: (() -> Void)?
    
    init(doubleKey: DoubleKey, doubleTapInterval: TimeInterval = 2.0) {
        self.doubleKey = doubleKey
        self.doubleTapInterval = doubleTapInterval
    }
    
    deinit {
        stop()
    }
    
    // MARK: - Start / Stop
    func start() {
        guard eventTap == nil else { return }
        
        let mask = (1 << CGEventType.keyDown.rawValue)
        let pointerToSelf = Unmanaged.passUnretained(self).toOpaque()
        
        eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(mask),
            callback: DoubleKeyMonitor.eventTapCallback,
            userInfo: pointerToSelf
        )
        
        guard let eventTap = eventTap else { return }
        
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
    }
    
    func stop() {
        if let eventTap = eventTap {
            CFMachPortInvalidate(eventTap)
            self.eventTap = nil
        }
    }
}

private extension DoubleKeyMonitor {
    // MARK: - Private
    func handleKeyPress() {
        let now = Date()
        if let last = lastKeyPress, now.timeIntervalSince(last) <= doubleTapInterval {
            onDoublePress?()
            lastKeyPress = nil
        } else {
            lastKeyPress = now
        }
    }

    // MARK: - C-compatible callback
    static let eventTapCallback: CGEventTapCallBack = { _, type, event, userInfo in
        guard type == .keyDown, let userInfo = userInfo else {
            return Unmanaged.passUnretained(event)
        }

        let monitor = Unmanaged<DoubleKeyMonitor>.fromOpaque(userInfo).takeUnretainedValue()
        let keyCode = CGKeyCode(event.getIntegerValueField(.keyboardEventKeycode))
        let flags = event.flags

        let pressedKey = DoubleKey(keyCode: keyCode, modifierFlags: flags)

        if monitor.doubleKey.matches(eventFlags: flags, keyCode: keyCode) {
            monitor.handleKeyPress()
        }

        return Unmanaged.passUnretained(event)
    }
}
