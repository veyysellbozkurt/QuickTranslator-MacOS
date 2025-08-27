//
//  FloatingIconWindowDelegate.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 27.08.2025.
//

import AppKit

protocol FloatingIconWindowDelegate: AnyObject {
    func floatingIconDidConfirmTranslate(_ window: FloatingIconWindow)
    func floatingIconDidCancel(_ window: FloatingIconWindow)
}

final class FloatingIconWindow: NSPanel {
    weak var actionDelegate: FloatingIconWindowDelegate?

    private let escKeyCode = 53
    private let button = NSButton()
    private var autoHideWorkItem: DispatchWorkItem?

    init(size: CGFloat = 36) {
        let rect = NSRect(x: 0, y: 0, width: size, height: size)
        super.init(contentRect: rect,
                   styleMask: [.borderless, .nonactivatingPanel],
                   backing: .buffered,
                   defer: false)

        isOpaque = false
        backgroundColor = .clear
        level = .floating
        hasShadow = true
        hidesOnDeactivate = false
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        ignoresMouseEvents = false

        button.title = ""
        button.isBordered = false
        button.bezelStyle = .regularSquare
        button.wantsLayer = true
        button.layer?.cornerRadius = size/2
        button.layer?.backgroundColor = NSColor.windowBackgroundColor.withAlphaComponent(0.95).cgColor
        button.contentTintColor = .systemBlue
        button.image = NSImage(systemSymbolName: "globe", accessibilityDescription: nil)
        button.imagePosition = .imageOnly
        button.target = self
        button.action = #selector(onClick)
        button.frame = rect.insetBy(dx: 2, dy: 2)
        button.autoresizingMask = [.width, .height]
        contentView?.addSubview(button)

      
        let esc = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] ev in
            guard let self = self else { return .none }
            if ev.keyCode == self.escKeyCode {
                self.actionDelegate?.floatingIconDidCancel(self)
                self.orderOut(nil)
                return nil
            }
            return ev
        }
    }

    @objc private func onClick() {
        actionDelegate?.floatingIconDidConfirmTranslate(self)
        orderOut(nil)
    }

    func showNearMouse(offset: NSPoint = NSPoint(x: 12, y: -24), autoHideAfter seconds: TimeInterval = 2) {
        let mouse = NSEvent.mouseLocation
        let origin = NSPoint(x: mouse.x + offset.x, y: mouse.y + offset.y)
        setFrameOrigin(origin)
        makeKeyAndOrderFront(nil)
        startAutoHide(seconds)
    }

    private func startAutoHide(_ seconds: TimeInterval) {
        autoHideWorkItem?.cancel()
        let work = DispatchWorkItem { [weak self] in self?.orderOut(nil) }
        autoHideWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: work)
    }
}
