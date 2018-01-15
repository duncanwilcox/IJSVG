//
//  AppDelegate.m
//  IJSVGExample
//
//  Created by Curtis Hard on 02/09/2014.
//  Copyright (c) 2014 Curtis Hard. All rights reserved.
//

#import "AppDelegate.h"
#import "SVGView.h"
#import <WebKit/WebKit.h>

@interface AppDelegate ()

@property (nonatomic, weak) IBOutlet NSWindow *window;
@property (nonatomic, weak) IBOutlet SVGView *svgView;
@property (nonatomic, weak) IBOutlet WebView *webView;

@end

@implementation AppDelegate
            
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self.svgView loadSVGNamed:@"test"];
    [self loadSVGInWebview:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"svg"]];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
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
            [weakSelf loadSVGInWebview:openPanel.URL.path];
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
    [self loadSVGInWebview:[[NSBundle mainBundle] pathForResource:[names objectAtIndex:tag] ofType:@"svg"]];
}

- (void)loadSVGInWebview:(NSString *)path
{
    NSString *svg = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData *svgData = [svg dataUsingEncoding:NSUTF8StringEncoding];
    NSString *b64 = [svgData base64EncodedStringWithOptions:0];
    NSString *html = [NSString stringWithFormat:@"<style>body { border: 0; padding: 0; margin: 0; }</style><div style=\"display: inline-block; background: url(data:image/svg+xml;base64,%@); background-size: contain; background-repeat: no-repeat; width: 100%%; height: 100%%; background-position: 50%% 50%%;\"></div>", b64];
    [self.webView.mainFrame loadHTMLString:html baseURL:nil];
}

@end
