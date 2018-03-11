//
//  String+Truncate.swift
//  Memor
//
//  Created by Thomas Carrill on 3/3/18.
//  Copyright © 2018 devcellar. All rights reserved.
//

import Foundation

extension String {
    func truncate(length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
}
