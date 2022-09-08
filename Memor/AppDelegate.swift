//
//  AppDelegate.swift
//  Memor
//
//  Created by Thomas Carrill on 2/28/18.
//  Copyright © 2018 devcellar. All rights reserved.
//

import Cocoa
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
  // **NOTE**: It is not recommended to set a default keyboard shortcut. Instead opt to show a setup on first app-launch to let the user define a shortcut, default shortcut: command+shift+return
  static let showFloatingPanel = Self("showFloatingPanel", default: .init(.return, modifiers: [.command, .shift]))
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    private var pasteboardWindow = PasteboardWindow()
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
        
        let pasteBoardWindowViewModel = PasteboardWindowViewModel(pasteboardData: pasteboardData)
        pasteboardWindow.setup(viewModel: pasteBoardWindowViewModel)
        
        pasteboardMonitor = PasteboardMonitor(pasteboardData: pasteboardData)
        
        KeyboardShortcuts.onKeyUp(for: .showFloatingPanel, action: {
            self.pasteboardWindow.showWindow(nil)
        })
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        print(NSKeyedArchiver.archiveRootObject(pasteboardData.items, toFile: filePath))
    }
    
    func getPasteboardData() -> PasteboardData {
        return pasteboardData
    }
    
    func getPasteboardWindow() -> PasteboardWindow {
        return pasteboardWindow
    }
    
}

