//
//  PasteboardWindowViewModel.swift
//  Memor
//
//  Created by Thomas Carrill on 3/11/18.
//  Copyright © 2018 devcellar. All rights reserved.
//

import Foundation

class PasteboardWindowViewModel: NSObject, Observer, Observable {
    var pasteboardData: PasteboardData
    var observers = [Observer]()
    
    init(pasteboardData: PasteboardData) {
        self.pasteboardData = pasteboardData
        super.init()
        self.pasteboardData.attach(observer: self)
    }
    
    var countSummary: String {
        return "x of " + String(describing: pasteboardData.items.count)
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
