//
//  SVGView.m
//  IJSVGExample
//
//  Created by Curtis Hard on 02/09/2014.
//  Copyright (c) 2014 Curtis Hard. All rights reserved.
//

#import "SVGView.h"
#import "IJSVGExporter.h"

@interface SVGView ()
@property (nonatomic, strong) IJSVG *svg;
@end

@implementation SVGView

- (void)loadSVGNamed:(NSString *)name
{
    __weak SVGView *weakSelf = self;
    self.svg = [IJSVG svgNamed:name];
    self.svg.renderingBackingScaleHelper = ^{
        return [weakSelf.svg computeBackingScale:weakSelf.window.backingScaleFactor];
    };
    [self setNeedsDisplay:YES];
}

- (void)loadSVGFile:(NSString *)file
{
    __weak SVGView *weakSelf = self;
    self.svg = [[IJSVG alloc] initWithFile:file];
    self.svg.renderingBackingScaleHelper = ^{
        return [weakSelf.svg computeBackingScale:weakSelf.window.backingScaleFactor];
    };
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    CGContextRef ref = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSaveGState(ref);
    CGContextSetRGBFillColor(ref, 1, 1, 1, 1);
    CGContextFillRect(ref, self.bounds);
    CGContextTranslateCTM( ref, 0, self.bounds.size.height);
    CGContextScaleCTM( ref, 1, -1 );
    [self.svg drawInRect:self.bounds];
    CGContextRestoreGState(ref);
}

@end
