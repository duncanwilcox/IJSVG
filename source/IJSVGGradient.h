//
//  IJSVGGradient.h
//  IJSVGExample
//
//  Created by Curtis Hard on 03/09/2014.
//  Copyright (c) 2014 Curtis Hard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IJSVGDef.h"
#import "IJSVGTransform.h"

@interface IJSVGGradient : IJSVGNode

@property ( nonatomic, strong ) NSGradient * gradient;
@property ( nonatomic, assign ) CGGradientRef CGGradient;
@property ( nonatomic, strong ) IJSVGUnitLength * x1;
@property ( nonatomic, strong ) IJSVGUnitLength * x2;
@property ( nonatomic, strong ) IJSVGUnitLength * y1;
@property ( nonatomic, strong ) IJSVGUnitLength * y2;

CGAffineTransform IJSVGAbsoluteTransform(CGPoint absolutePoint);

+ (CGFloat *)computeColorStopsFromString:(NSXMLElement *)element
                                  colors:(NSArray **)someColors;
- (CGGradientRef)CGGradient;
- (void)drawInContextRef:(CGContextRef)ctx
              parentRect:(NSRect)parentRect
             drawingRect:(NSRect)rect
        absolutePosition:(CGPoint)absolutePosition
                viewPort:(CGRect)viewBox;

@end
