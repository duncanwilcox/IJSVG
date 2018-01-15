//
//  AppDelegate.m
//  IJSVGExample
//
//  Created by Curtis Hard on 02/09/2014.
//  Copyright (c) 2014 Curtis Hard. All rights reserved.
//

#import "AppDelegate.h"
#import "SVGView.h"

@interface AppDelegate ()

@property (nonatomic, weak) IBOutlet NSWindow *window;
@property (nonatomic, weak) IBOutlet SVGView *svgView;

@end

@implementation AppDelegate
            
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)openDocument:(id)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseFiles = YES;
    openPanel.canChooseDirectories = NO;
    openPanel.allowsMultipleSelection = NO;
    openPanel.prompt = NSLocalizedString(@"Select", @"Select");
    openPanel.allowedFileTypes = @[ @"public.svg-image", @"svg" ];
    __block AppDelegate *weakSelf = self;
    [openPanel beginWithCompletionHandler:^(NSModalResponse returnCode) {
        if(returnCode == NSModalResponseOK)
        {
            [weakSelf.svgView loadSVGFile:openPanel.URL.path];
            [weakSelf.svgView setNeedsDisplay:YES];
        }
    }];
}

- (IBAction)loadSVGFromMenu:(id)sender
{
    NSInteger tag = [(NSMenuItem *)sender tag];
    NSArray *names = @[
                       @"test",
                       @"css",
                       @"clipped",
                       @"htc_one",
                       @"products",
                       @"paperplane",
                       @"linecap",
                       @"dashed"
                       ];
    [self.svgView loadSVGNamed:[names objectAtIndex:tag]];
    [self.svgView setNeedsDisplay:YES];
}

@end
