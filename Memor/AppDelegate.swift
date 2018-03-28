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
    private var pasteboardMonitor: PasteboardMonitor!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        UserDefaults.standard.register(defaults: [
            NotificationKey.confirmClearingItems: false,
            NotificationKey.removeFavoritesWhenClearing: false,
            NotificationKey.showCountInStatusItem: true,
            NotificationKey.showItemsInStatusMenu: true,
            NotificationKey.numberItemsInStatusMenu: "15"
        ])
        
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: NSHomeDirectory() + "savedItems.memor") as? [PasteboardItem] {
            pasteboardData.items = ourData
        }
        
        pasteboardMonitor = PasteboardMonitor(pasteboardData: pasteboardData)

        print("Application did finish launching")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        print("Application will terminate")
        print(NSKeyedArchiver.archiveRootObject(pasteboardData.items, toFile: NSHomeDirectory() + "savedItems.memor"))
    }
    
    func getPasteboardData() -> PasteboardData {
        return pasteboardData
    }
    
}

