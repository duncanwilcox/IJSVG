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
            NSString *fn = [NSString stringWithUTF8String:argv[1]];
            NSData *svgdata = [NSData dataWithContentsOfFile:fn];
            NSString *svg = [[NSString alloc] initWithData:svgdata encoding:NSUTF8StringEncoding];
            IJSVG *ijsvg = [[IJSVG alloc] initWithSVGString:svg error:nil];
            NSRect v = ijsvg.viewBox;
            NSImage *i = [ijsvg imageWithSize:CGSizeMake(v.size.width * 3, v.size.height * 3) flipped:YES];
            fn = [[fn stringByDeletingPathExtension] stringByAppendingPathExtension:@"png"];
            saveImage(i, fn);
        }
    }
    return 0;
}

void saveImage(NSImage *image, NSString *path)
{
    CGImageRef cgRef = [image CGImageForProposedRect:NULL context:nil hints:nil];
    NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
    [newRep setSize:[image size]];
    NSData *pngData = [newRep representationUsingType:NSPNGFileType properties:@{}];
    [pngData writeToFile:path atomically:YES];
}
