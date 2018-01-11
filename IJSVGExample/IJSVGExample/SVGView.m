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

- (id)initWithFrame:(NSRect)frameRect
{
    if( ( self = [super initWithFrame:frameRect] ) != nil )
    {
        __weak SVGView *weakSelf = self;
        self.svg = [self svg];
        self.svg.renderingBackingScaleHelper = ^{
            return [weakSelf.svg computeBackingScale:weakSelf.window.backingScaleFactor];
        };
    }
    return self;
}

- (IJSVG *)svg
{
    return [IJSVG svgNamed:@"test"];
}

- (void)drawRect:(NSRect)dirtyRect
{
    CGContextRef ref = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSaveGState(ref);
    CGContextTranslateCTM( ref, 0, self.bounds.size.height);
    CGContextScaleCTM( ref, 1, -1 );
    [self.svg drawInRect:self.bounds];
    CGContextRestoreGState(ref);
}

@end
