//
//  AppDelegate.swift
//  Memor
//
//  Created by Thomas Carrill on 2/28/18.
//  Copyright © 2018 devcellar. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let pasteboardData = PasteboardData()
    let filePath = NSHomeDirectory() + "/savedItems.memor"
    
    private var pasteboardMonitor: PasteboardMonitor!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        UserDefaults.standard.register(defaults: [
            NotificationKey.confirmClearingItems: false,
            NotificationKey.removeFavoritesWhenClearing: false,
            NotificationKey.showCountInStatusItem: true,
            NotificationKey.showItemsInStatusMenu: true,
            NotificationKey.numberItemsInStatusMenu: "15"
        ])
        
        if let savedData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [PasteboardItem] {
            pasteboardData.loadSavedItems(items: savedData)
        }
        
        pasteboardMonitor = PasteboardMonitor(pasteboardData: pasteboardData)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        print(NSKeyedArchiver.archiveRootObject(pasteboardData.items, toFile: filePath))
    }
    
    func getPasteboardData() -> PasteboardData {
        return pasteboardData
    }
    
}

