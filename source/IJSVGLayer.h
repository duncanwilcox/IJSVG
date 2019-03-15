//
//  IJSVGLayer.h
//  IJSVGExample
//
//  Created by Curtis Hard on 07/01/2017.
//  Copyright © 2017 Curtis Hard. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "IJSVGTransaction.h"
#import "IJSVGRendering.h"

@class IJSVGShapeLayer;
@class IJSVGGradientLayer;
@class IJSVGPatternLayer;
@class IJSVGStrokeLayer;
@class IJSVGGroupLayer;

@interface IJSVGLayer : CALayer

@property (nonatomic, unsafe_unretained) IJSVGGradientLayer * gradientFillLayer;
@property (nonatomic, unsafe_unretained) IJSVGPatternLayer * patternFillLayer;
@property (nonatomic, unsafe_unretained) IJSVGStrokeLayer * strokeLayer;
@property (nonatomic, unsafe_unretained) IJSVGGradientLayer * gradientStrokeLayer;
@property (nonatomic, unsafe_unretained) IJSVGPatternLayer * patternStrokeLayer;
@property (nonatomic, assign) BOOL requiresBackingScaleHelp;
@property (nonatomic, assign) CGFloat backingScaleFactor;
@property (nonatomic, assign) IJSVGRenderQuality renderQuality;
@property (nonatomic, assign) CGBlendMode blendingMode;
@property (nonatomic, assign) CGPoint absoluteOrigin;
@property (nonatomic, assign) BOOL convertMasksToPaths;

+ (NSArray *)deepestSublayersOfLayer:(CALayer *)layer;
+ (void)recursivelyWalkLayer:(CALayer *)layer
                   withBlock:(void (^)(CALayer * layer, BOOL isMask))block;

- (void)applySublayerMaskToContext:(CGContextRef)context
                       forSublayer:(IJSVGLayer *)sublayer
                        withOffset:(CGPoint)offset;

@end
