//
//  IJSVGGradientLayer.m
//  IJSVGExample
//
//  Created by Curtis Hard on 29/12/2016.
//  Copyright © 2016 Curtis Hard. All rights reserved.
//

#import "IJSVGGradientLayer.h"
#import "IJSVGLinearGradient.h"

@implementation IJSVGGradientLayer

@synthesize gradient;

- (void)dealloc
{
    [gradient release], gradient = nil;
    [super dealloc];
}

- (id)init
{
    if((self = [super init]) != nil) {
        self.requiresBackingScaleHelp = YES;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx
{
    [super drawInContext:ctx];
 
    // nothing to do :(
    if(self.gradient == nil) {
        return;
    }

    CGRect boundingBoxRect = self.frame;
    CGRect objectRect = self.superlayer.frame;
    if(self.gradient.units == IJSVGUnitUserSpaceOnUse) {
        boundingBoxRect = self.viewBox;
    }
    
    __block CGPoint startPoint;
    __block CGPoint endPoint;
    
    void (^applyTransform)(CGAffineTransform transform) = ^(CGAffineTransform transform) {
        startPoint = CGPointApplyAffineTransform(startPoint, transform);
        endPoint = CGPointApplyAffineTransform(endPoint, transform);
    };
    
    if([self.gradient isKindOfClass:[IJSVGLinearGradient class]]) {
        
        // basic start and end
        startPoint = (CGPoint) {
            .x = self.gradient.x1.value,
            .y = self.gradient.y1.value
        };
        
        endPoint = (CGPoint) {
            .x = self.gradient.x2.value,
            .y = self.gradient.y2.value
        };
        
        // only do these calculations if the type is %
        if(self.gradient.x2.type == IJSVGUnitLengthTypePercentage) {
            
            // move origin back due to user space
            if(self.gradient.units == IJSVGUnitUserSpaceOnUse) {
                CGPoint absolutePosition = self.absoluteOrigin;
                absolutePosition.x = (absolutePosition.x/CGRectGetWidth(boundingBoxRect));
                absolutePosition.y = (absolutePosition.y/CGRectGetHeight(boundingBoxRect));
                
                // apply the absolute transform
                CGAffineTransform transform;
                transform = CGAffineTransformMakeTranslation(-absolutePosition.x,
                                                             -absolutePosition.y);
                applyTransform(transform);
            }
            
            // apply the transforms specified on the gradient element
            for(IJSVGTransform * gradientTransform in self.gradient.transforms) {
                applyTransform(gradientTransform.CGAffineTransform);
            }
            
            // conver the points
            if(self.gradient.units == IJSVGUnitUserSpaceOnUse) {
                
                // start
                startPoint.x = ((startPoint.x - CGRectGetMinX(objectRect))/CGRectGetWidth(objectRect));
                startPoint.y = ((startPoint.y - CGRectGetMinY(objectRect))/CGRectGetHeight(objectRect));
                
                // end
                endPoint.x = ((endPoint.x - CGRectGetMaxX(objectRect))/CGRectGetWidth(objectRect)) + 1.f;
                endPoint.y = ((endPoint.y - CGRectGetMaxY(objectRect))/CGRectGetHeight(objectRect)) + 1.f;
            }
            
            // convert back to pixel values
            startPoint.x = CGRectGetWidth(objectRect)*startPoint.x;
            startPoint.y = CGRectGetHeight(objectRect)*startPoint.y;
            
            endPoint.x = CGRectGetWidth(objectRect)*endPoint.x;
            endPoint.y = CGRectGetHeight(objectRect)*endPoint.y;
            
        } else {
            
            // move the origin to the user space
            if(self.gradient.units == IJSVGUnitUserSpaceOnUse) {
                CGPoint absolutePosition = self.absoluteOrigin;
                
                // apply the absolute transform
                CGAffineTransform transform;
                transform = CGAffineTransformMakeTranslation(-absolutePosition.x,
                                                             -absolutePosition.y);
                applyTransform(transform);
            }
            
        }
        
        // start and end, draw before both and after
        CGGradientDrawingOptions options = kCGGradientDrawsBeforeStartLocation|
            kCGGradientDrawsAfterEndLocation;
        
        // draw the gradient
        CGContextDrawLinearGradient(ctx, self.gradient.CGGradient,
                                    startPoint, endPoint, options);
        
    }
}

@end
