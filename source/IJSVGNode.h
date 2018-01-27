//
//  IJSVGNode.h
//  IconJar
//
//  Created by Curtis Hard on 30/08/2014.
//  Copyright (c) 2014 Curtis Hard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IJSVGStyle.h"
#import "IJSVGUnitLength.h"

@class IJSVG;
@class IJSVGGroup;
@class IJSVGDef;
@class IJSVGGradient;
@class IJSVGGroup;
@class IJSVGPattern;

typedef NS_ENUM( NSInteger, IJSVGNodeType ) {
    IJSVGNodeTypeGroup,
    IJSVGNodeTypePath,
    IJSVGNodeTypeDef,
    IJSVGNodeTypePolygon,
    IJSVGNodeTypePolyline,
    IJSVGNodeTypeRect,
    IJSVGNodeTypeLine,
    IJSVGNodeTypeCircle,
    IJSVGNodeTypeEllipse,
    IJSVGNodeTypeUse,
    IJSVGNodeTypeLinearGradient,
    IJSVGNodeTypeRadialGradient,
    IJSVGNodeTypeClipPath,
    IJSVGNodeTypeFont,
    IJSVGNodeTypeGlyph,
    IJSVGNodeTypeMask,
    IJSVGNodeTypeImage,
    IJSVGNodeTypePattern,
    IJSVGNodeTypeSVG,
    IJSVGNodeTypeText,
    IJSVGNodeTypeTextSpan,
    IJSVGNodeTypeStyle,
    IJSVGNodeTypeSwitch,
    IJSVGNodeTypeA,
    IJSVGNodeTypeNotFound,
};

typedef NS_ENUM( NSInteger, IJSVGWindingRule ) {
    IJSVGWindingRuleNonZero,
    IJSVGWindingRuleEvenOdd,
    IJSVGWindingRuleInherit
};

typedef  NS_ENUM( NSInteger, IJSVGLineCapStyle ) {
    IJSVGLineCapStyleNone,
    IJSVGLineCapStyleButt,
    IJSVGLineCapStyleRound,
    IJSVGLineCapStyleSquare,
    IJSVGLineCapStyleInherit
};

typedef NS_ENUM( NSInteger, IJSVGLineJoinStyle ) {
    IJSVGLineJoinStyleNone,
    IJSVGLineJoinStyleMiter,
    IJSVGLineJoinStyleRound,
    IJSVGLineJoinStyleBevel,
    IJSVGLineJoinStyleInherit
};

typedef NS_OPTIONS( NSInteger, IJSVGFontTraits ) {
    IJSVGFontTraitNone = 1 << 0,
    IJSVGFontTraitBold = 1 << 1,
    IJSVGFontTraitItalic = 1 << 2
};

typedef NS_ENUM( NSInteger, IJSVGUnitType) {
    IJSVGUnitUserSpaceOnUse,
    IJSVGUnitObjectBoundingBox,
    IJSVGUnitInherit
};

typedef NS_ENUM( NSInteger, IJSVGBlendMode) {
    IJSVGBlendModeNormal = kCGBlendModeNormal,
    IJSVGBlendModeMultiply = kCGBlendModeMultiply,
    IJSVGBlendModeScreen = kCGBlendModeScreen,
    IJSVGBlendModeOverlay = kCGBlendModeOverlay,
    IJSVGBlendModeDarken = kCGBlendModeDarken,
    IJSVGBlendModeLighten = kCGBlendModeLighten,
    IJSVGBlendModeColorDodge = kCGBlendModeColorDodge,
    IJSVGBlendModeColorBurn = kCGBlendModeColorBurn,
    IJSVGBlendModeHardLight = kCGBlendModeHardLight,
    IJSVGBlendModeSoftLight = kCGBlendModeSoftLight,
    IJSVGBlendModeDifference = kCGBlendModeDifference,
    IJSVGBlendModeExclusion = kCGBlendModeExclusion,
    IJSVGBlendModeHue = kCGBlendModeHue,
    IJSVGBlendModeSaturation = kCGBlendModeSaturation,
    IJSVGBlendModeColor = kCGBlendModeColor,
    IJSVGBlendModeLuminosity = kCGBlendModeLuminosity
};

static CGFloat IJSVGInheritedFloatValue = -99.9999991;

@interface IJSVGNode : NSObject <NSCopying>

@property ( nonatomic, assign ) IJSVGNodeType type;
@property ( nonatomic, copy ) NSString * name;
@property ( nonatomic, copy ) NSString * className;
@property ( nonatomic, strong ) NSArray * classNameList;
@property ( nonatomic, copy ) NSString * unicode;
@property ( nonatomic, assign ) BOOL shouldRender;
@property ( nonatomic, assign ) BOOL usesDefaultFillColor;
@property ( nonatomic, strong ) IJSVGUnitLength * x;
@property ( nonatomic, strong ) IJSVGUnitLength * y;
@property ( nonatomic, strong ) IJSVGUnitLength * width;
@property ( nonatomic, strong ) IJSVGUnitLength * height;
@property ( nonatomic, strong ) IJSVGUnitLength * opacity;
@property ( nonatomic, strong ) IJSVGUnitLength * fillOpacity;
@property ( nonatomic, strong ) IJSVGUnitLength * strokeOpacity;
@property ( nonatomic, strong ) IJSVGUnitLength * strokeWidth;
@property ( nonatomic, strong ) NSColor * fillColor;
@property ( nonatomic, strong ) NSColor * strokeColor;
@property ( nonatomic, copy ) NSString * identifier;
@property ( nonatomic, weak ) IJSVGNode * parentNode;
@property ( nonatomic, strong ) IJSVGGroup * clipPath;
@property ( nonatomic, strong ) IJSVGGroup * mask;
@property ( nonatomic, assign ) IJSVGWindingRule windingRule;
@property ( nonatomic, assign ) IJSVGLineCapStyle lineCapStyle;
@property ( nonatomic, assign ) IJSVGLineJoinStyle lineJoinStyle;
@property ( nonatomic, strong ) NSArray * transforms;
@property ( nonatomic, strong ) IJSVGDef * def;
@property ( nonatomic, strong ) IJSVGGradient * fillGradient;
@property ( nonatomic, strong ) IJSVGPattern * fillPattern;
@property ( nonatomic, strong ) IJSVGGradient * strokeGradient;
@property ( nonatomic, strong ) IJSVGPattern * strokePattern;
@property ( nonatomic, assign ) CGFloat * strokeDashArray;
@property ( nonatomic, assign ) NSInteger strokeDashArrayCount;
@property ( nonatomic, strong ) IJSVGUnitLength * strokeDashOffset;
@property ( nonatomic, strong ) IJSVG * svg;
@property ( nonatomic, assign ) IJSVGUnitType contentUnits;
@property ( nonatomic, assign ) IJSVGUnitType units;
@property ( nonatomic, assign ) IJSVGBlendMode blendMode;

+ (IJSVGNodeType)typeForString:(NSString *)string
                          kind:(NSXMLNodeKind)kind;

- (void)applyPropertiesFromNode:(IJSVGNode *)node;
- (id)initWithDef:(BOOL)flag;
- (void)addDef:(IJSVGNode *)aDef;
- (IJSVGDef *)defForID:(NSString *)anID;

@end
