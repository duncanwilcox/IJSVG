//
//  IJSVGImageLayer.h
//  IJSVGExample
//
//  Created by Curtis Hard on 07/01/2017.
//  Copyright © 2017 Curtis Hard. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "IJSVGLayer.h"

@interface IJSVGImageLayer : IJSVGLayer

- (id)initWithImage:(NSImage *)image;
- (id)initWithCGImage:(id)imageRef;

@end
