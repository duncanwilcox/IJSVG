//
//  IJSVGFontConverter.h
//  IJSVGExample
//
//  Created by Curtis Hard on 21/05/2015.
//  Copyright (c) 2015 Curtis Hard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IJSVGFontConverter : NSObject

- (id)initWithFontAtFileURL:(NSURL *)url;
- (NSDictionary *)paths;
+ (NSBezierPath *)bezierpathFromCGPath:(CGPathRef)path;
- (NSFont *)font;

@end
