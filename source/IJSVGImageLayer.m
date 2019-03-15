//
//  IJSVGImageLayer.m
//  IJSVGExample
//
//  Created by Curtis Hard on 07/01/2017.
//  Copyright © 2017 Curtis Hard. All rights reserved.
//

#import "IJSVGImageLayer.h"

@implementation IJSVGImageLayer

- (id)initWithImage:(NSImage *)image
{
    NSRect rect = (NSRect){
        .origin = NSZeroPoint,
        .size = image.size
    };
    CGImageRef ref = [image CGImageForProposedRect:&rect
                                           context:nil
                                             hints:nil];
    return [self initWithCGImage:(__bridge id)ref];
}

- (id)initWithCGImage:(id)imageRef
{
    if((self = [super init]) != nil) {
        // set the contents
        self.contents = imageRef;
        
        // make sure we say we need help
        self.requiresBackingScaleHelp = YES;
        self.shouldRasterize = YES;

        // set the frame, simple stuff
        self.frame = (CGRect){
            .origin = CGPointZero,
            .size = CGSizeMake(CGImageGetWidth((CGImageRef)imageRef),
                               CGImageGetHeight((CGImageRef)imageRef))
        };
    }
    return self;
}

- (void)setNeedsDisplay
{
    // swap the content around on call
    // because set needs display discards previous
    // content - yolo!
    id oldContent = self.contents;
    [super setNeedsDisplay];
    self.contents = oldContent;
}

@end
