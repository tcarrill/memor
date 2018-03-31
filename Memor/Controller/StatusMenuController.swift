//
//  StatusMenuController.swift
//  Memor
//
//  Created by Thomas Carrill on 2/28/18.
//  Copyright © 2018 devcellar. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject, Observer {

    @IBOutlet weak var statusMenu: NSMenu!

    private var preferencesWindow: PreferencesWindow!
    private var pasteboardWindow: PasteboardWindow!
    private var viewModel: StatusMenuViewModel!
    private var pasteMenuItems = [NSMenuItem]()

    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let pasteMenuItemStartIndex = 3
    private let attributes = [
        NSAttributedStringKey.font: NSFont(name: "Avenir Next Bold", size: 14.0)!
    ]
    
    override func awakeFromNib() {
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        let pasteboardData = appDelegate.getPasteboardData()
        
        viewModel = StatusMenuViewModel(pasteboardData: pasteboardData)
        viewModel.attach(observer: self)
        
        let summaryMenuItem = NSMenuItem(title: viewModel.countSummary,
                                  action: #selector(summaryClicked(_:)),
                                  keyEquivalent: "")
        summaryMenuItem.target = self
        statusMenu.insertItem(summaryMenuItem, at: 0)
        statusItem.menu = statusMenu
        
        let pasteBoardWindowViewModel = PasteboardWindowViewModel(pasteboardData: pasteboardData)
        pasteboardWindow = PasteboardWindow(viewModel: pasteBoardWindowViewModel)
        preferencesWindow = PreferencesWindow()
        
        statusItem.attributedTitle = NSAttributedString(string: viewModel.statusItemTitle, attributes: attributes)
        statusItem.toolTip = viewModel.statusItemToolTip
    }
    
    // MARK: - UI Actions
    @IBAction func clearItemsClicked(_ sender: NSMenuItem) {
        if (UserDefaults.standard.bool(forKey: NotificationKey.confirmClearingItems)) {
            var text = "All items in your copy history will be cleared."
            if (UserDefaults.standard.bool(forKey: NotificationKey.removeFavoritesWhenClearing)) {
                text = "All items, including favorites, in your copy history will be cleared."
            }
            let answer = dialogOKCancel(question: "Clear Items?", text: text)
            if (answer) {
                viewModel.clearItems()
            }
        } else {
            viewModel.clearItems()
        }
    }
    
    @IBAction func preferencesClicked(_ sender: NSMenuItem) {
        preferencesWindow.showWindow(sender)
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }

    @objc private func summaryClicked(_ sender: NSMenuItem) {
        pasteboardWindow.showWindow(sender)
    }
    
    @objc private func itemClicked(_ sender: NSMenuItem) {
        print("itemClicked: " + sender.title)
    }
    
    // MARK: -
    
    private func createMenuItem(title: String) -> NSMenuItem {
        let menuItem = NSMenuItem(title: title,
                                  action: #selector(itemClicked(_:)),
                                  keyEquivalent: "")
        menuItem.target = self
        pasteMenuItems.append(menuItem)
        return menuItem
    }
    
    private func removePasteboardMenuItems() {
        for item in pasteMenuItems {
            statusItem.menu?.removeItem(item)
        }
        pasteMenuItems.removeAll()
    }
    
    private func updatePasteboardMenuItems() {
        for item in viewModel.menuItemTitles {
            statusItem.menu?.insertItem(createMenuItem(title: item), at: pasteMenuItemStartIndex)
        }
    }
    
    func dialogOKCancel(question: String, text: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        return alert.runModal() == .alertFirstButtonReturn
    }
    
    // MARK: - Observer protocol
    
    func update() {
        statusItem.attributedTitle = NSAttributedString(string: viewModel.statusItemTitle, attributes: attributes)
        statusItem.menu?.item(at: 0)?.title = viewModel.countSummary
        removePasteboardMenuItems()
        updatePasteboardMenuItems()
    }
}
