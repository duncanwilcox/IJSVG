//
//  main.m
//  svg_to_png
//
//  Created by Duncan Wilcox on 11/01/2018.
//  Copyright © 2018 Curtis Hard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IJSVG.h"

void saveImage(NSImage *image, NSString *path);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if(argc > 1)
        {
            printf("%s\n", argv[1]);
            NSString *fn = [NSString stringWithUTF8String:argv[1]];
            NSData *svgdata = [NSData dataWithContentsOfFile:fn];
            NSString *svg = [[NSString alloc] initWithData:svgdata encoding:NSUTF8StringEncoding];
            IJSVG *ijsvg = [[IJSVG alloc] initWithSVGString:svg error:nil];
//            NSSize s = CGSizeMake(ceil(ijsvg.viewBox.size.width * 3), ceil(ijsvg.viewBox.size.height * 3));
            NSSize s = CGSizeMake(400, 400);
            NSImage *i = [ijsvg imageWithSize:s flipped:YES];
            fn = [[fn stringByDeletingPathExtension] stringByAppendingPathExtension:@"png"];
            saveImage(i, fn);
        }
    }
    return 0;
}

void saveImage(NSImage *image, NSString *path)
{
    [image lockFocus];
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0, 0, image.size.width, image.size.height)];
    [image unlockFocus];
    
    bitmapRep =
        [bitmapRep bitmapImageRepByConvertingToColorSpace:[NSColorSpace genericRGBColorSpace]
                                          renderingIntent:NSColorRenderingIntentDefault];
    
    NSData *pngData = [bitmapRep representationUsingType:NSPNGFileType properties:@{NSImageColorSyncProfileData:[NSColorSpace genericRGBColorSpace]}];
    [pngData writeToFile:path atomically:YES];
}
