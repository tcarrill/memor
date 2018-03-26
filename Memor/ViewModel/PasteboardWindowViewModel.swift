//
//  PasteboardWindowViewModel.swift
//  Memor
//
//  Created by Thomas Carrill on 3/11/18.
//  Copyright © 2018 devcellar. All rights reserved.
//  test

import Foundation

class PasteboardWindowViewModel: NSObject, Observer, Observable {
    var pasteboardData: PasteboardData
    var pasteboardIndex: Int
    var observers = [Observer]()
    
    init(pasteboardData: PasteboardData) {
        self.pasteboardData = pasteboardData
        self.pasteboardIndex = 0
        super.init()
        self.pasteboardData.attach(observer: self)
    }
    
    func decrementPasteboardIndex() {
        pasteboardIndex -= 1
        if (pasteboardIndex < 0) {
            pasteboardIndex = pasteboardData.items.count - 1
        }
    }
    
    func incrementPasteboardIndex() {
        pasteboardIndex += 1
        if (pasteboardIndex > pasteboardData.items.count - 1) {
            pasteboardIndex = 0
        }
    }
    
    var countSummary: String {
        let displayIndex = pasteboardData.items.count == 0 ? pasteboardIndex : pasteboardIndex + 1
        var summary = "\(displayIndex) of \(pasteboardData.items.count)"
        if (pasteboardData.items.count > 0 && pasteboardData.items[pasteboardIndex].favorite) {
            summary = summary + " ❤"
        }
        return summary
    }
    
    func getCurrentItem() -> String {
        if (!pasteboardData.items.isEmpty) {
            return pasteboardData.items[pasteboardIndex].text
        }
        return "Pasteboard is empty"
    }
    
    func toggleFavoriteForCurrentItem() {
        pasteboardData.toggleFavorite(index: pasteboardIndex)
    }
    
    // MARK: - Observer protocol
    func update() {
        notify()
    }
    
    // MARK: - Observable protocol
    func attach(observer: Observer) {
        observers.append(observer)
    }
    
    func detach(observer: Observer) {
        
    }
    
    func notify() {
        for observer in observers {
            observer.update()
        }
    }
}
