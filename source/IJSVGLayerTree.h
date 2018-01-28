//
//  IJSVGLayerTree.h
//  IJSVGExample
//
//  Created by Curtis Hard on 29/12/2016.
//  Copyright © 2016 Curtis Hard. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "IJSVGNode.h"

@class IJSVGLayer;

@interface IJSVGLayerTree : NSObject

@property (nonatomic, assign) CGRect viewBox;
@property (nonatomic, strong) NSColor * fillColor;
@property (nonatomic, strong) NSColor * strokeColor;
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, assign) IJSVGLineJoinStyle lineJoinStyle;
@property (nonatomic, assign) IJSVGLineCapStyle lineCapStyle;
@property (nonatomic, strong) NSDictionary<NSColor *, NSColor *> * replacementColors;

- (IJSVGLayer *)layerForNode:(IJSVGNode *)node;

+ (void)debug:(IJSVGLayer *)rootLayer;

@end
