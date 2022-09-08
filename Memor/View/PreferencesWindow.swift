//
//  PreferencesWindow.swift
//  Memor
//
//  Created by Thomas Carrill on 2/28/18.
//  Copyright © 2018 devcellar. All rights reserved.
//

import Cocoa

class PreferencesWindow: NSWindowController {
    
    override var windowNibName : NSNib.Name! {
        return NSNib.Name("PreferencesWindow")
    }
    
    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
}
