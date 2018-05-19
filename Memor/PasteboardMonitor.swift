//
//  PasteboardMonitor.swift
//  Memor
//
//  Created by Thomas Carrill on 3/2/18.
//  Copyright © 2018 devcellar. All rights reserved.
//

import Foundation
import AppKit

class PasteboardMonitor {
    private let pasteboard = NSPasteboard.general
    private var pasteboardData: PasteboardData
    
    init(pasteboardData: PasteboardData) {
        self.pasteboardData = pasteboardData
        Timer.scheduledTimer(timeInterval: 0.5,
                             target: self,
                             selector: #selector(poll),
                             userInfo: nil,
                             repeats: true)
    }
    
    @objc private func poll() {
        if (pasteboard.changeCount != pasteboardData.previousChangeCount) {
            pasteboardData.previousChangeCount = pasteboard.changeCount
            let text = pasteboard.pasteboardItems![0].string(forType: NSPasteboard.PasteboardType(rawValue: "public.utf8-plain-text"))!
            pasteboardData.insert(text: text)
        }
    }
}
