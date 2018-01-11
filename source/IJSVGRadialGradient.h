//
//  IJSVGRadialGradient.h
//  IJSVGExample
//
//  Created by Curtis Hard on 03/09/2014.
//  Copyright (c) 2014 Curtis Hard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IJSVGGradient.h"

@interface IJSVGRadialGradient : IJSVGGradient

@property ( nonatomic, strong ) IJSVGUnitLength * cx;
@property ( nonatomic, strong ) IJSVGUnitLength * cy;
@property ( nonatomic, strong ) IJSVGUnitLength * fx;
@property ( nonatomic, strong ) IJSVGUnitLength * fy;
@property ( nonatomic, strong ) IJSVGUnitLength * radius;

+ (NSGradient *)parseGradient:(NSXMLElement *)element
                     gradient:(IJSVGRadialGradient *)gradient
                   startPoint:(CGPoint *)startPoint
                     endPoint:(CGPoint *)endPoint;

@end
