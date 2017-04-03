//
//  IJSVGRadialGradient.m
//  IJSVGExample
//
//  Created by Curtis Hard on 03/09/2014.
//  Copyright (c) 2014 Curtis Hard. All rights reserved.
//

#import "IJSVGRadialGradient.h"

@implementation IJSVGRadialGradient

@synthesize cx;
@synthesize cy;
@synthesize fx;
@synthesize fy;
@synthesize radius;

- (void)dealloc
{
    [cx release], cx = nil;
    [cy release], cy = nil;
    [fx release], fx = nil;
    [fy release], fy = nil;
    [radius release], radius = nil;
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone
{
    IJSVGRadialGradient * grad = [super copyWithZone:zone];
    grad.fx = self.fx;
    grad.fy = self.fy;
    grad.cx = self.cx;
    grad.cy = self.cy;
    grad.radius = self.radius;
    grad.startPoint = self.startPoint;
    grad.endPoint = self.endPoint;
    return grad;
}


+ (NSGradient *)parseGradient:(NSXMLElement *)element
                     gradient:(IJSVGRadialGradient *)gradient
                   startPoint:(CGPoint *)startPoint
                     endPoint:(CGPoint *)endPoint
{
    CGFloat cx = [element attributeForName:@"cx"].stringValue.floatValue;
    CGFloat cy = [element attributeForName:@"cy"].stringValue.floatValue;
    CGFloat radius = [element attributeForName:@"r"].stringValue.floatValue;
    
    // work out each coord, and work out if its a % or not
    // check all against all
    BOOL isPercent = NO;
    if(cx <= 1.f && cy <= 1.f && radius <= 1.f) {
        isPercent = YES;
    } else if((cx >= 0.f && cx <= 1.f) && (cy >= 0.f && cy <= 1.f) &&
              (radius >= 0.f && radius <= 1.f)) {
        isPercent = YES;
    }
    
    if(isPercent == NO) {
        // just unit value
        gradient.cx = [IJSVGGradientUnitLength unitWithString:[element attributeForName:@"cx"].stringValue];
        gradient.cy = [IJSVGGradientUnitLength unitWithString:[element attributeForName:@"cy"].stringValue];
        gradient.radius = [IJSVGGradientUnitLength unitWithString:[element attributeForName:@"r"].stringValue];
    } else {
        // make sure its a percent
        gradient.cx = [IJSVGGradientUnitLength unitWithPercentageString:[element attributeForName:@"cx"].stringValue];
        gradient.cy = [IJSVGGradientUnitLength unitWithPercentageString:[element attributeForName:@"cy"].stringValue];
        gradient.radius = [IJSVGGradientUnitLength unitWithPercentageString:[element attributeForName:@"r"].stringValue];
    }
    
    
    // check for nullability
    if( gradient.gradient != nil ) {
        return nil;
    }
    
    *startPoint = CGPointMake(gradient.cx.valueAsPercentage, gradient.cy.valueAsPercentage);
    *endPoint = CGPointMake(gradient.fx.valueAsPercentage, gradient.fy.valueAsPercentage);
    
    NSArray * colors = nil;
    CGFloat * colorStops = [[self class] computeColorStopsFromString:element colors:&colors];
    NSGradient * ret = [[[NSGradient alloc] initWithColors:colors
                                               atLocations:colorStops
                                                colorSpace:[NSColorSpace genericRGBColorSpace]] autorelease];
    free(colorStops);
    return ret;
}

- (CGFloat)_handleTransform:(IJSVGTransform *)transform
                     bounds:(CGRect)bounds
                      index:(NSInteger)index
                      value:(CGFloat)value
{
    // rotate transform, assume its based on percentages
    // if lower then 0 is specified for 1 or 2
    CGFloat max = bounds.size.width>bounds.size.height?bounds.size.width:bounds.size.height;
    if( transform.command == IJSVGTransformCommandRotate ) {
        switch(index) {
            case 1:
            case 2: {
                if(value<1.f) {
                    return (max*value);
                }
                break;
            }
        }
    }
    return value;

}

- (void)drawInContextRef:(CGContextRef)ctx
                    rect:(NSRect)rect
{
    CGRect bounds = rect;
    for( IJSVGTransform * transform in self.transforms ) {
        IJSVGTransformParameterModifier modifier = ^CGFloat(NSInteger index, CGFloat value) {
            return [self _handleTransform:transform
                                   bounds:bounds
                                    index:index
                                    value:value];
        };
        CGContextConcatCTM(ctx, [transform CGAffineTransformWithModifier:modifier]);
    }
    
    CGPoint sp = self.startPoint;
    CGPoint ep = self.endPoint;
    
    if( self.startPoint.x == .5f ) {
        sp.x = bounds.size.width*self.startPoint.x;
    }
    
    if(self.startPoint.y == .5f) {
        sp.y = bounds.size.height*self.startPoint.y;
    }
    
    if(self.endPoint.x == .5f) {
        ep.x = bounds.size.width*self.endPoint.x;
    }
    
    if(self.endPoint.y == .5f) {
        ep.y = bounds.size.height*self.endPoint.y;
    }
    
    CGFloat r = self.radius.value;
    if(r == .5f) {
        r = (sp.x>sp.y?sp.x:sp.y);
    }
    
    // actually perform the draw
    CGGradientDrawingOptions options = kCGGradientDrawsBeforeStartLocation|kCGGradientDrawsAfterEndLocation;
    CGGradientRef grad = self.CGGradient;
    CGContextDrawRadialGradient(ctx, grad, sp, 0.f, ep, r, options);
}

@end
