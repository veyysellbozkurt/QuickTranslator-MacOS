//
//  DoubleKey.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 5.09.2025.
//

import Carbon.HIToolbox

struct DoubleKey: Equatable {
    let keyCode: CGKeyCode
    let modifierFlags: CGEventFlags
    
    static let cmdC = DoubleKey(keyCode: CGKeyCode(kVK_ANSI_C), modifierFlags: .maskCommand)
    static let cmdX = DoubleKey(keyCode: CGKeyCode(kVK_ANSI_X), modifierFlags: .maskCommand)
    static let cmdV = DoubleKey(keyCode: CGKeyCode(kVK_ANSI_V), modifierFlags: .maskCommand)
    static let optionX = DoubleKey(keyCode: CGKeyCode(kVK_ANSI_X), modifierFlags: .maskAlternate)
}

extension DoubleKey {
    func matches(eventFlags: CGEventFlags, keyCode: CGKeyCode) -> Bool {
        return self.keyCode == keyCode && eventFlags.contains(self.modifierFlags)
    }
}
