//
//  PRAppDelegate.m
//  PicRenamer
//
//  Created by PJW on 2013-3-16.
//  Copyright (c) 2013 PrettyX. All rights reserved.
//

#import "PRAppDelegate.h"
#import "PRFileInfo.h"

@implementation PRAppDelegate
@synthesize allFileInfo = _allFileInfo;
@synthesize tableView = _tableView;


- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender{
    return YES;
}

- (NSMutableArray *)allFileInfo{
    if (!_allFileInfo) _allFileInfo = [[NSMutableArray alloc]init];
    return _allFileInfo;
}

- (IBAction)showOpenPanel:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowedFileTypes:[NSImage imageFileTypes]];
    [openPanel setAllowsMultipleSelection:YES];
    [openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result==NSOKButton) {
            NSArray *urls = [openPanel URLs];
            for ( NSURL *pastUrl in urls) {
                NSData *imageData = [NSData dataWithContentsOfURL:pastUrl];
                CGImageSourceRef source = CGImageSourceCreateWithData(CFBridgingRetain(imageData), NULL);
                NSDictionary *metaData = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(source,0,NULL));
                NSDictionary *exifData = [metaData objectForKey:@"{Exif}"];
                NSString *date;
                if ([exifData objectForKey:@"DateTimeOriginal"]) date = [exifData objectForKey:@"DateTimeOriginal"];
                else  date = [exifData objectForKey:@"DateTimeDigitized"];
                if (date) {
                    NSRange range; range.location = 0; range.length = [date length];
                    date = [date stringByReplacingOccurrencesOfString:@":" withString:@"-" options:1 range:range];
                    NSURL *nowUrl = [[[pastUrl URLByDeletingLastPathComponent]URLByAppendingPathComponent:date]URLByAppendingPathExtension:[pastUrl pathExtension]];
                    PRFileInfo *temp = [[PRFileInfo alloc]init];
                    temp.pastUrl = pastUrl; temp.nowUrl = nowUrl;
                    if(![self.allFileInfo containsObject:temp]) [self.allFileInfo addObject:temp];
                }
            }
            [self.tableView reloadData];
        }
    }];
    [self.tableView reloadData];
}

- (IBAction)clearAllFiles:(NSButton *)sender {
    [self.allFileInfo removeAllObjects];
    [self.tableView reloadData];
}

- (IBAction)renameFiles:(NSButton *)sender {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (PRFileInfo *now in self.allFileInfo){
        [fileManager moveItemAtURL:now.pastUrl toURL:now.nowUrl error:nil];
        now.pastUrl = now.nowUrl;
    }
    [self.tableView reloadData];
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [self.allFileInfo count];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if ([[tableColumn identifier] isEqualToString:@"Before"]) return [[[self.allFileInfo objectAtIndex:row] pastUrl] lastPathComponent];
    else if ([[tableColumn identifier] isEqualToString:@"After"]) return [[[self.allFileInfo objectAtIndex:row] nowUrl] lastPathComponent];
    else return nil;
}

@end
