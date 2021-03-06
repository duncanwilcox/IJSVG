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
{
    // work out each coord, and work out if its a % or not
    // annoyingly we need to check them all against each other -_-
    BOOL isPercent = aGradient.units == IJSVGUnitObjectBoundingBox;
    
    // assume its a vertical / horizonal
    if(isPercent == NO) {
        // just ask unit for the value
        aGradient.x1 = [IJSVGGradientUnitLength unitWithString:[[element attributeForName:@"x1"] stringValue] ?: @"0"];
        aGradient.x2 = [IJSVGGradientUnitLength unitWithString:[[element attributeForName:@"x2"] stringValue] ?: @"100"];
        aGradient.y1 = [IJSVGGradientUnitLength unitWithString:[[element attributeForName:@"y1"] stringValue] ?: @"0"];
        aGradient.y2 = [IJSVGGradientUnitLength unitWithString:[[element attributeForName:@"y2"] stringValue] ?: @"0"];
    } else {
        // make sure its a percent!
        aGradient.x1 = [IJSVGGradientUnitLength unitWithPercentageString:[[element attributeForName:@"x1"] stringValue] ?: @"0"];
        aGradient.x2 = [IJSVGGradientUnitLength unitWithPercentageString:[[element attributeForName:@"x2"] stringValue] ?: @"1"];
        aGradient.y1 = [IJSVGGradientUnitLength unitWithPercentageString:[[element attributeForName:@"y1"] stringValue] ?: @"0"];
        aGradient.y2 = [IJSVGGradientUnitLength unitWithPercentageString:[[element attributeForName:@"y2"] stringValue] ?: @"0"];
    }

    // compute the color stops and colours
    NSArray * colors = nil;
    CGFloat * stopsParams = [self.class computeColorStopsFromString:element
                                                               colors:&colors];
    
    // create the gradient with the colours
    NSGradient * grad = [[NSGradient alloc] initWithColors:colors
                                               atLocations:stopsParams
                                                colorSpace:IJSVGColor.defaultColorSpace];
    
    free(stopsParams);
    return grad;
}

- (void)drawInContextRef:(CGContextRef)ctx
              objectRect:(NSRect)objectRect
       absoluteTransform:(CGAffineTransform)absoluteTransform
                viewPort:(CGRect)viewBox
{
    BOOL inUserSpace = self.units == IJSVGUnitUserSpaceOnUse;
    
    CGPoint gradientStartPoint = CGPointZero;
    CGPoint gradientEndPoint = CGPointZero;
    CGAffineTransform absTransform = absoluteTransform;
    CGAffineTransform selfTransform = IJSVGConcatTransforms(self.transforms);
    
    CGRect boundingBox = inUserSpace ? viewBox : objectRect;
    
    // make sure we apply the absolute position to
    // transform us back into the correct space
    if(inUserSpace == YES) {
        CGContextConcatCTM(ctx, absTransform);
    }
    
    CGFloat width = CGRectGetWidth(boundingBox);
    CGFloat height = CGRectGetHeight(boundingBox);
    gradientStartPoint = CGPointMake([self.x1 computeValue:width],
                                     [self.y1 computeValue:height]);
    
    gradientEndPoint = CGPointMake([self.x2 computeValue:width],
                                   [self.y2 computeValue:height]);

    // transform the context
    CGContextConcatCTM(ctx, selfTransform);
    
    // draw the gradient
    CGGradientDrawingOptions options =
        kCGGradientDrawsBeforeStartLocation|
        kCGGradientDrawsAfterEndLocation;
    
    CGContextDrawLinearGradient(ctx, self.CGGradient, gradientStartPoint,
                                gradientEndPoint, options);
}

@end
