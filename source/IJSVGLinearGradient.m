//
//  IJSVGGradient.m
//  IJSVGExample
//
//  Created by Curtis Hard on 03/09/2014.
//  Copyright (c) 2014 Curtis Hard. All rights reserved.
//

#import "IJSVGLinearGradient.h"
#import "IJSVGUtils.h"

@implementation IJSVGLinearGradient

+ (NSGradient *)parseGradient:(NSXMLElement *)element
                     gradient:(IJSVGLinearGradient *)aGradient
                   startPoint:(CGPoint *)startPoint
                     endPoint:(CGPoint *)endPoint
{
    
    CGFloat px1 = [[element attributeForName:@"x1"] stringValue].floatValue;
    CGFloat px2 = [[element attributeForName:@"x2"] stringValue].floatValue;
    CGFloat py1 = [[element attributeForName:@"y1"] stringValue].floatValue;
    CGFloat py2 = [[element attributeForName:@"y2"] stringValue].floatValue;
    
    // work out each coord, and work out if its a % or not
    // annoyingly we need to check them all against each other -_-
    BOOL isPercent = NO;
    if(px1 <= 1.f && px2 <= 1.f && py1 <= 1.f && py2 <= 1.f) {
        isPercent = YES;
    } else if((px1 >= 0.f && px1 <= 1.f) && (px2 >= 0.f && px2 <= 1.f) &&
              (py1 >= 0.f && py1 <= 1.f) && (py2 >= 0.f && py2 <= 1.f)) {
        isPercent = YES;
    }
    
    // assume its a vertical / horizonal
    if(isPercent == NO) {
        // just ask unit for the value
        aGradient.x1 = [IJSVGUnitLength unitWithString:[[element attributeForName:@"x1"] stringValue] ?: @"0"];
        aGradient.x2 = [IJSVGUnitLength unitWithString:[[element attributeForName:@"x2"] stringValue] ?: @"100"];
        aGradient.y1 = [IJSVGUnitLength unitWithString:[[element attributeForName:@"y1"] stringValue] ?: @"0"];
        aGradient.y2 = [IJSVGUnitLength unitWithString:[[element attributeForName:@"y2"] stringValue] ?: @"0"];
    } else {
        // make sure its a percent!
        aGradient.x1 = [IJSVGUnitLength unitWithPercentageString:[[element attributeForName:@"x1"] stringValue] ?: @"0"];
        aGradient.x2 = [IJSVGUnitLength unitWithPercentageString:[[element attributeForName:@"x2"] stringValue] ?: @"1"];
        aGradient.y1 = [IJSVGUnitLength unitWithPercentageString:[[element attributeForName:@"y1"] stringValue] ?: @"0"];
        aGradient.y2 = [IJSVGUnitLength unitWithPercentageString:[[element attributeForName:@"y2"] stringValue] ?: @"0"];
    }

    // compute the color stops and colours
    NSArray * colors = nil;
    CGFloat * stopsParams = [[self class] computeColorStopsFromString:element
                                                               colors:&colors];
    
    // create the gradient with the colours
    NSGradient * grad = [[[NSGradient alloc] initWithColors:colors
                                               atLocations:stopsParams
                                                colorSpace:[NSColorSpace genericRGBColorSpace]] autorelease];
    
    free(stopsParams);
    return grad;
}

- (void)drawInContextRef:(CGContextRef)ctx
                    rect:(NSRect)rect
{
    // grab the start and end point
    CGPoint aStartPoint = CGPointZero;
    CGPoint aEndPoint = CGPointZero;
    CGFloat parentXOffset = 0.f;
    CGFloat parentYOffset = 0.f;
    if(self.units == IJSVGUnitUserSpaceOnUse) {
        parentXOffset = (rect.origin.x/rect.size.width);
        parentYOffset = (rect.origin.y/rect.size.height);
    }
    
    // work out if its percentage
    if(self.x1.type == IJSVGUnitLengthTypePercentage) {
        aStartPoint = (CGPoint){
            .x = self.x1.value-parentXOffset,
            .y = self.y1.value-parentYOffset
        };
        aEndPoint = (CGPoint){
            .x = self.x2.value-parentXOffset,
            .y = self.y2.value-parentYOffset
        };
    } else {
        aStartPoint = (CGPoint){
            .x = (self.x1.value/rect.size.width)-parentXOffset,
            .y = (self.y1.value/rect.size.height)-parentYOffset
        };
        aEndPoint = (CGPoint){
            .x = (self.x2.value/rect.size.width)-parentXOffset,
            .y = (self.y2.value/rect.size.height)-parentYOffset
        };
    }
    
    // convert the nsgradient to a CGGradient
    CGGradientRef gRef = [self CGGradient];
    
//    // apply transform for each point
//    for( IJSVGTransform * transform in self.transforms ) {
//        CGAffineTransform trans = transform.CGAffineTransform;
//        aStartPoint = CGPointApplyAffineTransform(aStartPoint, trans);
//        aEndPoint = CGPointApplyAffineTransform(aEndPoint, trans);
//    }
    
    // draw the gradient
    CGGradientDrawingOptions opt = kCGGradientDrawsBeforeStartLocation|kCGGradientDrawsAfterEndLocation;
    CGContextDrawLinearGradient(ctx, gRef, aStartPoint, aEndPoint, opt);
    
    NSRect r = NSZeroRect;
    r.origin = aStartPoint;
    r.size = NSMakeSize(2.f, 2.f);
    CGContextFillRect(ctx, r);
    
    r.origin = aEndPoint;
    CGContextFillRect(ctx, r);    
}

@end
