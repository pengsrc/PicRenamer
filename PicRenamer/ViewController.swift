//
//  ViewController.swift
//  PicRenamer
//
//  Created by Peng Jingwen on 2015-02-26.
//  Copyright (c) 2015 PrettyX. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTabViewDelegate {

    @IBOutlet weak var table: NSTableView!
    var allFilesInfo = Array<String>()
    
    override func viewDidLoad() {
        allFilesInfo.append("abc")
    }
    
    func updateUI(){
        self.table.reloadData()
        self.table.setNeedsDisplay()
    }
    
    @IBAction func openFiles(sender: NSButton) {
        
        self.updateUI()
    }
    
    @IBAction func clearFiles(sender: NSButton) {
        self.allFilesInfo.removeAll(keepCapacity: false)
        self.updateUI()
    }
    
    @IBAction func renameFiles(sender: NSButton) {
        
        self.updateUI()
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return self.allFilesInfo.count
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        return self.allFilesInfo[row]
    }
    
}
