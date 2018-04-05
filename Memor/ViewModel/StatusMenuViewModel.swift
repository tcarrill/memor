//
//  StatusMenuViewModel.swift
//  Memor
//
//  Created by Thomas Carrill on 3/6/18.
//  Copyright © 2018 devcellar. All rights reserved.
//

import Foundation

class StatusMenuViewModel: NSObject, Observer, Observable {
    var pasteboardData: PasteboardData
    var menuItemTitles = [String]()
    var observers = [Observer]()
    let statusItemPrefix = "M"
    let statusItemToolTip = "Memor"
    var statusItemTitle: String
    
    init(pasteboardData: PasteboardData) {
        self.pasteboardData = pasteboardData
        statusItemTitle = statusItemPrefix
        super.init()
        UserDefaults.standard.addObserver(self,
                                          forKeyPath: NotificationKey.showCountInStatusItem,
                                          options: NSKeyValueObservingOptions.new,
                                          context: nil)
        UserDefaults.standard.addObserver(self,
                                          forKeyPath: NotificationKey.numberItemsInStatusMenu,
                                          options: NSKeyValueObservingOptions.new,
                                          context: nil)
        UserDefaults.standard.addObserver(self,
                                          forKeyPath: NotificationKey.showItemsInStatusMenu,
                                          options: NSKeyValueObservingOptions.new,
                                          context: nil)
        UserDefaults.standard.addObserver(self,
                                          forKeyPath: NotificationKey.favoriteIcon,
                                          options: NSKeyValueObservingOptions.new,
                                          context: nil)
        pasteboardData.attach(observer: self)
    }
    
    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: NotificationKey.showCountInStatusItem)
        UserDefaults.standard.removeObserver(self, forKeyPath: NotificationKey.numberItemsInStatusMenu)
        UserDefaults.standard.removeObserver(self, forKeyPath: NotificationKey.showItemsInStatusMenu)
        UserDefaults.standard.removeObserver(self, forKeyPath: NotificationKey.favoriteIcon)
    }
    
    var countSummary: String {
        var countSummary = String(describing: pasteboardData.items.count) + " Item"
        if (pasteboardData.items.count != 1) {
            countSummary = countSummary + "s"
        }
        return countSummary
    }
    
    var isClearItemsEnabled: Bool {
        return pasteboardData.items.count > 0
    }

    private func updateStatusItemTitle() {
        if (UserDefaults.standard.bool(forKey: NotificationKey.showCountInStatusItem)) {
            statusItemTitle = statusItemPrefix + String(describing: pasteboardData.items.count)
        } else {
            statusItemTitle = statusItemPrefix
        }
    }
    
    private func updateMenuItemTitles() {
        let numItems = UserDefaults.standard.integer(forKey: NotificationKey.numberItemsInStatusMenu)
        let items = pasteboardData.getNItems(n: numItems)
        menuItemTitles.removeAll()
        
        for item in items {
            var title = item.text
            if (item.favorite) {
                title = UserDefaults.standard.string(forKey: NotificationKey.favoriteIcon)! + " " + title
            }
            title = title.trimmingCharacters(in: .whitespacesAndNewlines).truncate(length: 50)
            menuItemTitles.insert(title, at: 0)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if (keyPath == NotificationKey.showCountInStatusItem) {
            updateStatusItemTitle()
        } else if (keyPath == NotificationKey.numberItemsInStatusMenu) {
            updateMenuItemTitles()
        } else if (keyPath == NotificationKey.showItemsInStatusMenu) {
            if (!UserDefaults.standard.bool(forKey: NotificationKey.showItemsInStatusMenu)) {
                menuItemTitles.removeAll()
            } else {
                updateMenuItemTitles()
            }
        } else if (keyPath == NotificationKey.favoriteIcon) {
            updateMenuItemTitles()
        }
        
        notify()
    }
    
    func clearAllItems() {
        pasteboardData.clearAllItems()
    }
    
    func clearItems() {
        pasteboardData.clearItems()
    }
    
    // MARK: - Observer protocol
    
    func update() {
        updateStatusItemTitle()
        updateMenuItemTitles()
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
