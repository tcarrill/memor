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
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        UserDefaults.standard.register(defaults: [
            NotificationKey.confirmClearingItems: false,
            NotificationKey.removeFavoritesWhenClearing: false,
            NotificationKey.showCountInStatusItem: true,
            NotificationKey.showItemsInStatusMenu: true,
            NotificationKey.numberItemsInStatusMenu: "15"
        ])
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

