//
//  Observable.swift
//  Memor
//
//  Created by Thomas Carrill on 3/8/18.
//  Copyright © 2018 devcellar. All rights reserved.
//

import Foundation

protocol Observable {
    func attach(observer: Observer)
    func detach(observer: Observer)
    func notify()
}
