//
//  FloatingQuickActionPanel.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 27.08.2025.
//

import AppKit

protocol FloatingQuickActionPanelDelegate: AnyObject {
    func quickActionPanelDidConfirm()
    func quickActionPanelDidCancel()
}

final class FloatingQuickActionPanel: NSPanel {
    
    weak var actionDelegate: FloatingQuickActionPanelDelegate?

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
        button.bezelStyle = .automatic
        button.wantsLayer = true
        if let layer = button.layer {
            layer.masksToBounds = false
            layer.cornerRadius = 15
            layer.shadowColor = NSColor.labelColor.cgColor
            layer.shadowOpacity = 0
            layer.shadowOffset = CGSize(width: 0, height: 1)
            layer.shadowRadius = 3
        }

        let buttonImage = FeatureManager.shared.menuBarIcon.image
        buttonImage.size = NSSize(width: 32, height: 32)
        buttonImage.isTemplate = false
        button.image = buttonImage
        button.imagePosition = .imageOnly
        button.target = self
        button.action = #selector(onClick)
        button.frame = rect.insetBy(dx: 2, dy: 2)
        button.autoresizingMask = [.width, .height]
        contentView?.addSubview(button)
      
        let _ = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] ev in
            guard let self = self else { return .none }
            if ev.keyCode == self.escKeyCode {
                self.actionDelegate?.quickActionPanelDidCancel()
                self.orderOut(nil)
                return nil
            }
            return ev
        }
    }

    @objc private func onClick() {
        actionDelegate?.quickActionPanelDidConfirm()
        orderOut(nil)
    }

    func showNearMouse(offset: NSPoint = NSPoint(x: 16, y: -48), autoHideAfter seconds: TimeInterval = 2) {
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
