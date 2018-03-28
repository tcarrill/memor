//
//  PasteboardWindow.swift
//  Memor
//
//  Created by Thomas Carrill on 3/11/18.
//  Copyright © 2018 devcellar. All rights reserved.
//

import Cocoa

class PasteboardWindow: NSWindowController, Observer {
    
    @IBOutlet weak var label: NSTextField!
    @IBOutlet weak var itemLabel: NSTextField!
    
    var viewModel: PasteboardWindowViewModel!
    
    override var windowNibName : NSNib.Name! {
        return NSNib.Name(rawValue: "PasteboardWindow")
    }
    
    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        label.stringValue = viewModel.countSummary
        itemLabel.stringValue = viewModel.getCurrentItem()
//        NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) {
//            self.flagsChanged(with: $0)
//            return $0
//        }
//        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
//            self.keyDown(with: $0)
//            return $0
//        }
    }
    
    init(viewModel: PasteboardWindowViewModel) {
        self.viewModel = viewModel
        super.init(window: nil)
        self.viewModel.attach(observer: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented, use init(viewModel:)")
    }
    
    override func keyDown(with event: NSEvent) {
        print(event.keyCode)
        if (event.keyCode == 123) { // Left arrow
            viewModel.decrementPasteboardIndex()
        } else if (event.keyCode == 124) { // Right arrow
            viewModel.incrementPasteboardIndex()
        } else if (event.keyCode == 3) { // f: Favorite item
            viewModel.toggleFavoriteForCurrentItem()
        }
        label.stringValue = viewModel.countSummary
        itemLabel.stringValue = viewModel.getCurrentItem()
    }
    
//    override func flagsChanged(with event: NSEvent) {
//        switch event.modifierFlags.intersection(.deviceIndependentFlagsMask) {
//        case [.shift]:
//            print("shift key is pressed")
//        case [.control]:
//            print("control key is pressed")
//        case [.option] :
//            print("option key is pressed")
//        case [.command]:
//            print("Command key is pressed")
//        case [.control, .shift]:
//            print("control-shift keys are pressed")
//        case [.option, .shift]:
//            print("option-shift keys are pressed")
//        case [.command, .shift]:
//            print("command-shift keys are pressed")
//        case [.control, .option]:
//            print("control-option keys are pressed")
//        case [.control, .command]:
//            print("control-command keys are pressed")
//        case [.option, .command]:
//            print("option-command keys are pressed")
//        case [.shift, .control, .option]:
//            print("shift-control-option keys are pressed")
//        case [.shift, .control, .command]:
//            print("shift-control-command keys are pressed")
//        case [.control, .option, .command]:
//            print("control-option-command keys are pressed")
//        case [.shift, .command, .option]:
//            print("shift-command-option keys are pressed")
//        case [.shift, .control, .option, .command]:
//            print("shift-control-option-command keys are pressed")
//        default:
//            print("no modifier keys are pressed")
//        }
//    }
    
    func update() {
        if (label != nil) {
            label.stringValue = viewModel.countSummary
        }
        if (itemLabel != nil) {
            itemLabel.stringValue = viewModel.getCurrentItem()
        }
    }
    
}
