//
//  IJSVGTransform.h
//  IconJar
//
//  Created by Curtis Hard on 01/09/2014.
//  Copyright (c) 2014 Curtis Hard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IJSVGUtils.h"

typedef CGFloat (^IJSVGTransformParameterModifier)(NSInteger index, CGFloat value);

typedef NS_OPTIONS( NSInteger, IJSVGTransformCommand ) {
    IJSVGTransformCommandMatrix,
    IJSVGTransformCommandTranslate,
    IJSVGTransformCommandScale,
    IJSVGTransformCommandRotate,
    IJSVGTransformCommandSkewX,
    IJSVGTransformCommandSkewY,
    IJSVGTransformCommandNotImplemented
};

@interface IJSVGTransform : NSObject

@property ( nonatomic, assign ) IJSVGTransformCommand command;
@property ( nonatomic, assign ) CGFloat * parameters;
@property ( nonatomic, assign ) NSInteger parameterCount;
@property ( nonatomic, assign ) NSInteger sort;

+ (NSArray *)transformsForString:(NSString *)string;
+ (NSBezierPath *)transformedPath:(IJSVGPath *)path;
+ (NSArray<NSString *> *)affineTransformToSVGTransformAttributeString:(CGAffineTransform)affineTransform;
- (CGAffineTransform)CGAffineTransform;
- (CGAffineTransform)CGAffineTransformWithModifier:(IJSVGTransformParameterModifier)modifier;
- (CGAffineTransform)stackIdentity:(CGAffineTransform)identity;
- (void)recalculateWithBounds:(CGRect)bounds;

@end
