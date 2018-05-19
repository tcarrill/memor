//
//  PasteboardItems.swift
//  Memor
//
//  Created by Thomas Carrill on 3/7/18.
//  Copyright © 2018 devcellar. All rights reserved.
//

import Foundation

class PasteboardData: NSObject, Observable {
    var previousChangeCount: Int
    var items = [PasteboardItem]()
    var observers = [Observer]()
    var favoriteCount = 0;
    
    init(changeCount: Int) {
        previousChangeCount = changeCount
    }
    
    func insert(text: String) {
        items.insert(PasteboardItem(text: text, favorite: false), at: 0)
        notify()
    }
    
    func loadSavedItems(items: [PasteboardItem]) {
        self.items = items
        for item in self.items {
            if (item.favorite) {
                favoriteCount += 1
            }
        }
        notify()
    }
    
    func getNItems(n: Int) -> [PasteboardItem] {
        var topN = [PasteboardItem]()
        if (!items.isEmpty) {
            var max = n
            if (max > items.count) {
                max = items.count
            }
            
            topN = Array<PasteboardItem>(items[0..<max])
        }
        return topN
    }
    
    func deleteItem(index: Int) {
        let item = items.remove(at: index)
        if (item.favorite) {
            favoriteCount -= 1
        }
        notify()
    }
    
    func clearAllItems() {
        items.removeAll()
        notify()
    }
    
    func clearItems() {
        items = items.filter { $0.favorite != false }
        notify()
    }
    
    func toggleFavorite(index: Int) {
        items[index].favorite = !items[index].favorite
        favoriteCount += items[index].favorite ? 1 : -1
        notify()
    }
    
    // MARK: - Observable
    
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
