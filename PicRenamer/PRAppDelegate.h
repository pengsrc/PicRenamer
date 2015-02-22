//
//  PRAppDelegate.h
//  PicRenamer
//
//  Created by PJW on 2013-3-16.
//  Copyright (c) 2013 PrettyX. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PRAppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTabViewDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (nonatomic, strong) NSMutableArray *allFileInfo;
@property (weak) IBOutlet NSTableView *tableView;

- (IBAction)showOpenPanel:(id)sender;
- (IBAction)clearAllFiles:(NSButton *)sender;
- (IBAction)renameFiles:(NSButton *)sender;

@end
