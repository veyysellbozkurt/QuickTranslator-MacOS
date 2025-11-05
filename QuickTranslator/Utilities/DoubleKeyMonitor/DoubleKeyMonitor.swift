//
//  DoubleKeyMonitor.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 27.08.2025.
//

import AppKit
import Cocoa
import ApplicationServices

final class DoubleKeyMonitor {
    
    private let doubleTapInterval: TimeInterval
    private var lastKeyPress: Date?
    private var eventTap: CFMachPort?
    private let doubleKey: DoubleKey
    
    var onDoublePress: (() -> Void)?
    
    init(doubleKey: DoubleKey, doubleTapInterval: TimeInterval = 1.2) {
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
        
        guard let eventTap = eventTap else {
            DoubleKeyMonitor.showAccessibilityPermissionAlert()
            return
        }
        
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
    
    static func isAccessibilityPermissionGranted() -> Bool {
        AXIsProcessTrusted()
    }
    
    static func showAccessibilityPermissionAlert() {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.alertStyle = .warning
            alert.messageText = Constants.Strings.accessibilityTitle

            let textView = NSTextView(frame: NSRect(x: 0, y: 0, width: 260, height: 150))
            textView.isEditable = false
            textView.drawsBackground = false
            textView.font = NSFont.systemFont(ofSize: 12)
            textView.string = Constants.Strings.accessibilityMessage
            alert.accessoryView = textView

            alert.addButton(withTitle: Constants.Strings.openSettings)
            alert.addButton(withTitle: Constants.Strings.cancel)

            if alert.runModal() == .alertFirstButtonReturn {
                if let url = Constants.Urls.accessibilitySettingsURL {
                    NSWorkspace.shared.open(url)
                }
            }
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
