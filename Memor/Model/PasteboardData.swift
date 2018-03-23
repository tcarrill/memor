//
//  PasteboardItems.swift
//  Memor
//
//  Created by Thomas Carrill on 3/7/18.
//  Copyright © 2018 devcellar. All rights reserved.
//

import Foundation

class PasteboardData: NSObject, Observable {
    var items = [PasteboardItem]()
    var observers = [Observer]()
    
    func insert(text: String) {
        items.insert(PasteboardItem(text: text, favorite: false), at: 0)
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
    
    func clearAllItems() {
        items.removeAll()
        notify()
    }
    
    func clearItems() {
//        let removableItems = items.filter { $0.favorite == false }
        notify()
    }
    
    func toggleFavorite(index: Int) {
        items[index].favorite = !items[index].favorite
        notify()
    }
    
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
