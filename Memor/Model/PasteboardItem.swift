//
//  PasteboardItem.swift
//  Memor
//
//  Created by Thomas Carrill on 3/7/18.
//  Copyright © 2018 devcellar. All rights reserved.
//

import Foundation

class PasteboardItem: NSObject {
    let text: String
    let created: Date
    var favorite: Bool
    
    init(text: String, favorite: Bool) {
        self.text = text
        self.favorite = favorite
        created = Date()
    }
}
