//
//  main.m
//  wk_svg_to_png
//
//  Created by Duncan Wilcox on 16/01/2018.
//  Copyright © 2018 Curtis Hard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "IJSVG.h"

BOOL done = NO;
void loadSVGInWebview(WebView *wv, NSString *path);
void saveImage(NSBitmapImageRep *rep, NSString *path);

@interface Loader : NSObject<WebFrameLoadDelegate>
@end

@implementation Loader
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    done = YES;
}
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if(argc > 1)
        {
            printf("%s\n", argv[1]);
            
            NSString *fn = [NSString stringWithUTF8String:argv[1]];
            NSData *svgdata = [NSData dataWithContentsOfFile:fn];
            NSString *svg = [[NSString alloc] initWithData:svgdata encoding:NSUTF8StringEncoding];
            IJSVG *ijsvg = [[IJSVG alloc] initWithSVGString:svg error:nil];
            
            NSRect r = NSMakeRect(0, 0, ceil(ijsvg.viewBox.size.width * 3), ceil(ijsvg.viewBox.size.height * 3));
            
            WebView *wv = [[WebView alloc] initWithFrame:r];
            [wv setDrawsBackground:NO];
            Loader *l = [[Loader alloc] init];
            wv.frameLoadDelegate = l;
            
            WebPreferences *prefs = [wv preferences];
            [prefs setPlugInsEnabled:NO];
            [prefs setJavaEnabled:NO];
            [prefs setJavaScriptCanOpenWindowsAutomatically:NO];
            [prefs setAllowsAnimatedImages:NO];

            loadSVGInWebview(wv, fn);

            while(!done)
                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.1]];

            NSBitmapImageRep *rep = [wv bitmapImageRepForCachingDisplayInRect:r];
            [wv cacheDisplayInRect:r toBitmapImageRep:rep];

            fn = [[[fn stringByDeletingPathExtension] stringByAppendingString:@"-webkit"] stringByAppendingPathExtension:@"png"];
            saveImage(rep, fn);
        }
    }
    return 0;
}

void loadSVGInWebview(WebView *wv, NSString *path)
{
    NSString *svg = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData *svgData = [svg dataUsingEncoding:NSUTF8StringEncoding];
    NSString *b64 = [svgData base64EncodedStringWithOptions:0];
    NSString *html = [NSString stringWithFormat:@"<style>body { border: 0; padding: 0; margin: 0; }</style><div style=\"display: inline-block; background: url(data:image/svg+xml;base64,%@); background-size: contain; background-repeat: no-repeat; width: 100%%; height: 100%%; background-position: 50%% 50%%;\"></div>", b64];
    [wv.mainFrame loadHTMLString:html baseURL:nil];
}

void saveImage(NSBitmapImageRep *rep, NSString *path)
{
    NSData *pngData = [rep representationUsingType:NSPNGFileType properties:@{NSImageColorSyncProfileData:[NSColorSpace genericRGBColorSpace]}];
    [pngData writeToFile:path atomically:YES];
}
