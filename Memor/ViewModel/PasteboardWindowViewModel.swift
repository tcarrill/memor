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
        UserDefaults.standard.addObserver(self,
                                          forKeyPath: NotificationKey.favoriteIcon,
                                          options: NSKeyValueObservingOptions.new,
                                          context: nil)
        self.pasteboardData.attach(observer: self)
    }
    
    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: NotificationKey.favoriteIcon)
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if (keyPath == NotificationKey.favoriteIcon) {
            notify()
        }
    }
    
    func deleteCurrentItem() {
        let oldIndex = pasteboardIndex
        if (pasteboardIndex == pasteboardData.items.count - 1) {
                pasteboardIndex -= 1
        }
        pasteboardData.deleteItem(index: oldIndex)
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
            summary = summary + " " + UserDefaults.standard.string(forKey: NotificationKey.favoriteIcon)!
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
        for i in 0 ..< observers.count {
            if observers[i] === observer {
                observers.remove(at: i)
                break
            }
        }
    }
    
    func notify() {
        for observer in observers {
            observer.update()
        }
    }
}
