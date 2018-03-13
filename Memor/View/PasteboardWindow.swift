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
    
    var viewModel: PasteboardWindowViewModel!
    
    override var windowNibName : NSNib.Name! {
        return NSNib.Name(rawValue: "PasteboardWindow")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        label.stringValue = viewModel.countSummary
    }
    
    init(viewModel: PasteboardWindowViewModel) {
        self.viewModel = viewModel
        super.init(window: nil)
        self.viewModel.attach(observer: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented, use init(viewModel:)")
    }
    
    func update() {
        if (label != nil) {
            label.stringValue = viewModel.countSummary
        }
    }
    
}
