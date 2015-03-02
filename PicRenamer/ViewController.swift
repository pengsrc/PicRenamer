//
//  ViewController.swift
//  PicRenamer
//
//  Created by Peng Jingwen on 2015-02-26.
//  Copyright (c) 2015 PrettyX. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTabViewDelegate {

    class FileURLGroup {
        var oldFileURL: NSURL
        var newFileURL: NSURL
        
        init(oldFileURL: NSURL, newFileURL: NSURL) {
            self.oldFileURL = oldFileURL
            self.newFileURL = newFileURL
        }
    }
    
    @IBOutlet weak var table: NSTableView!
    var fileURLGroups = Array<FileURLGroup>()
    
    func updateUI(){
        self.table.reloadData()
        self.table.setNeedsDisplay()
    }
    
    @IBAction func openFiles(sender: NSButton) {
        var openPanel = NSOpenPanel()
        openPanel.allowedFileTypes = NSImage.imageFileTypes()
        openPanel.allowsMultipleSelection = true
        
        if let window = NSApplication.sharedApplication().windows.first as? NSWindow {
            openPanel.beginSheetModalForWindow(window, completionHandler: { (result: Int) -> Void in
                
                if result == NSOKButton {
                    
                    for object in openPanel.URLs {
                        if let URL = object as? NSURL {
        
                            let imageData = NSData(contentsOfURL: URL)
                            let imageSource = CGImageSourceCreateWithData(CFBridgingRetain(imageData) as CFData, nil)
                            let metaDictionary = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as NSDictionary
                            let exifData = metaDictionary["{Exif}"] as NSDictionary
                            
                            var dateStringCapture: String?
                            dateStringCapture = exifData["DateTimeDigitized"] as? String
                            dateStringCapture = exifData["DateTimeOriginal"] as? String
                            
                            if let dateString = dateStringCapture {
                                
                                let newDateString = dateString.stringByReplacingOccurrencesOfString(
                                    ":",
                                    withString: "-",
                                    options: NSStringCompareOptions.LiteralSearch,
                                    range: nil
                                )
                                
                                let fileURL = FileURLGroup(
                                    oldFileURL: URL,
                                    newFileURL:
                                        URL.URLByDeletingLastPathComponent!
                                        .URLByAppendingPathComponent(newDateString)
                                        .URLByAppendingPathExtension(URL.pathExtension!)
                                )
                                
                                self.fileURLGroups.append(fileURL)
                            }
                        }
                    }
                    
                    self.updateUI()
                }
            })
        }
    }
    
    @IBAction func renameFiles(sender: NSButton) {
        let fileManager = NSFileManager.defaultManager()
        
        for group in self.fileURLGroups {
            fileManager.moveItemAtURL(group.oldFileURL, toURL: group.newFileURL, error: nil)
            group.oldFileURL = group.newFileURL
        }
        
        self.updateUI()
    }
    
    @IBAction func clearFiles(sender: NSButton) {
        self.fileURLGroups.removeAll(keepCapacity: false)
        self.updateUI()
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return self.fileURLGroups.count
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        if tableColumn?.identifier == "Before" {
            return self.fileURLGroups[row].oldFileURL.lastPathComponent
        } else if tableColumn?.identifier == "After" {
            return self.fileURLGroups[row].newFileURL.lastPathComponent
        } else {
            return nil
        }
    }
    
}
