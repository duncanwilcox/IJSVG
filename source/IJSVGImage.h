//
//  IJSVGImage.h
//  IJSVGExample
//
//  Created by Curtis Hard on 28/05/2016.
//  Copyright © 2016 Curtis Hard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IJSVGNode.h"

@class IJSVGPath;

@interface IJSVGImage : IJSVGNode

@property (nonatomic, strong) id CGImage;

- (void)drawInContextRef:(CGContextRef)context
                    path:(IJSVGPath *)path;
- (void)loadFromBase64EncodedString:(NSString *)encodedString;

@end
