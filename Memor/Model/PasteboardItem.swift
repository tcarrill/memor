//
//  PasteboardItem.swift
//  Memor
//
//  Created by Thomas Carrill on 3/7/18.
//  Copyright © 2018 devcellar. All rights reserved.
//

import Foundation

class PasteboardItem: NSObject, NSCoding {
    struct Keys {
        static let text = "text"
        static let created = "created"
        static let favorite = "favorite"
    }
    
    let text: String
    let created: Date
    var favorite: Bool
    
    init(text: String, favorite: Bool) {
        self.text = text
        self.favorite = favorite
        created = Date()
    }
    
    // MARK: - NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.text, forKey: Keys.text)
        aCoder.encode(self.created, forKey: Keys.created)
        aCoder.encode(self.favorite, forKey: Keys.favorite)
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: Keys.text) as! String
        created = aDecoder.decodeObject(forKey: Keys.created) as! Date
        favorite = aDecoder.decodeBool(forKey: Keys.favorite)
        super.init()
    }
    
    static func ==(lhs: PasteboardItem, rhs: PasteboardItem) -> Bool {
        return lhs.text == rhs.text &&
            lhs.created == rhs.created &&
            lhs.favorite == rhs.favorite
    }
}
