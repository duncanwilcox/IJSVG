//
//  IJSVGParser.h
//  IconJar
//
//  Created by Curtis Hard on 30/08/2014.
//  Copyright (c) 2014 Curtis Hard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IJSVGForeignObject.h"
#import "IJSVGGroup.h"
#import "IJSVGPath.h"
#import "IJSVGUtils.h"
#import "IJSVGCommand.h"
#import "IJSVGColor.h"
#import "IJSVGTransform.h"
#import "IJSVGDef.h"
#import "IJSVGLinearGradient.h"
#import "IJSVGRadialGradient.h"
#import "IJSVGError.h"
#import "IJSVGStyleSheet.h"
#import "IJSVGPattern.h"
#import "IJSVGImage.h"
#import "IJSVGText.h"

static NSString * IJSVGAttributeViewBox = @"viewBox";
static NSString * IJSVGAttributeID = @"id";
static NSString * IJSVGAttributeClass = @"class";
static NSString * IJSVGAttributeX = @"x";
static NSString * IJSVGAttributeY = @"y";
static NSString * IJSVGAttributeWidth = @"width";
static NSString * IJSVGAttributeHeight = @"height";
static NSString * IJSVGAttributeOpacity = @"opacity";
static NSString * IJSVGAttributeStrokeOpacity = @"stroke-opacity";
static NSString * IJSVGAttributeStrokeWidth = @"stroke-width";
static NSString * IJSVGAttributeStrokeDashOffset = @"stroke-dashoffset";
static NSString * IJSVGAttributeFillOpacity = @"fill-opacity";
static NSString * IJSVGAttributeClipPath = @"clip-path";
static NSString * IJSVGAttributeMask = @"mask";
static NSString * IJSVGAttributeGradientUnits = @"gradientUnits";
static NSString * IJSVGAttributeMaskUnits = @"maskUnits";
static NSString * IJSVGAttributeMaskContentUnits = @"maskContentUnits";
static NSString * IJSVGAttributeTransform = @"transform";
static NSString * IJSVGAttributeGradientTransform = @"gradientTransform";
static NSString * IJSVGAttributeUnicode = @"unicode";
static NSString * IJSVGAttributeStrokeLineCap = @"stroke-linecap";
static NSString * IJSVGAttributeLineJoin = @"stroke-linejoin";
static NSString * IJSVGAttributeStroke = @"stroke";
static NSString * IJSVGAttributeStrokeDashArray = @"stroke-dasharray";
static NSString * IJSVGAttributeFill = @"fill";
static NSString * IJSVGAttributeFillRule = @"fill-rule";
static NSString * IJSVGAttributeBlendMode = @"mix-blend-mode";
static NSString * IJSVGAttributeDisplay = @"display";
static NSString * IJSVGAttributeStyle = @"style";
static NSString * IJSVGAttributeD = @"d";
static NSString * IJSVGAttributeXLink = @"xlink:href";
static NSString * IJSVGAttributeX1 = @"x1";
static NSString * IJSVGAttributeX2 = @"x2";
static NSString * IJSVGAttributeY1 = @"y1";
static NSString * IJSVGAttributeY2 = @"y2";
static NSString * IJSVGAttributeRX = @"rx";
static NSString * IJSVGAttributeRY = @"ry";
static NSString * IJSVGAttributeCX = @"cx";
static NSString * IJSVGAttributeCY = @"cy";
static NSString * IJSVGAttributeR = @"r";
static NSString * IJSVGAttributePoints = @"points";

@class IJSVGParser;

@protocol IJSVGParserDelegate <NSObject>

@optional
- (BOOL)svgParser:(IJSVGParser *)svg
shouldHandleForeignObject:(IJSVGForeignObject *)foreignObject;
- (void)svgParser:(IJSVGParser *)svg
handleForeignObject:(IJSVGForeignObject *)foreignObject
   document:(NSXMLDocument *)document;
- (void)svgParser:(IJSVGParser *)svg
      foundSubSVG:(IJSVG *)subSVG
    withSVGString:(NSString *)string;

@end

@interface IJSVGParser : IJSVGGroup {
    
    NSRect viewBox;
    NSSize proposedViewSize;
    
@private
    id<IJSVGParserDelegate> _delegate;
    NSXMLDocument * _document;
    NSMutableArray * _glyphs;
    IJSVGStyleSheet * _styleSheet;
    NSMutableArray * _parsedNodes;
    NSMutableDictionary * _defNodes;
    NSMutableDictionary * _baseDefNodes;
    NSMutableArray<IJSVG *> * _svgs;
    
    struct {
        unsigned int shouldHandleForeignObject: 1;
        unsigned int handleForeignObject: 1;
        unsigned int handleSubSVG: 1;
    } _respondsTo;
}

@property ( nonatomic, readonly ) NSRect viewBox;
@property ( nonatomic, readonly ) NSSize proposedViewSize;

- (id)initWithSVGString:(NSString *)string
                  error:(NSError **)error
               delegate:(id<IJSVGParserDelegate>)delegate;

- (id)initWithFileURL:(NSURL *)aURL
                error:(NSError **)error
             delegate:(id<IJSVGParserDelegate>)delegate;
+ (IJSVGParser *)groupForFileURL:(NSURL *)aURL;
+ (IJSVGParser *)groupForFileURL:(NSURL *)aURL
                        delegate:(id<IJSVGParserDelegate>)delegate;
+ (IJSVGParser *)groupForFileURL:(NSURL *)aURL
                           error:(NSError **)error
                        delegate:(id<IJSVGParserDelegate>)delegate;
- (NSSize)size;
- (BOOL)isFont;
- (NSArray *)glyphs;
- (NSArray<IJSVG *> *)subSVGs:(BOOL)recursive;

@end
