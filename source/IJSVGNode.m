//
//  IJSVGNode.m
//  IconJar
//
//  Created by Curtis Hard on 30/08/2014.
//  Copyright (c) 2014 Curtis Hard. All rights reserved.
//

#import "IJSVGNode.h"
#import "IJSVGDef.h"
#import "IJSVGGradient.h"
#import "IJSVGPattern.h"
#import "IJSVGGroup.h"
#import "IJSVG.h"

@implementation IJSVGNode

- (void)dealloc
{
    free(self.strokeDashArray);
}

+ (IJSVGNodeType)typeForString:(NSString *)string
                          kind:(NSXMLNodeKind)kind
{
    string = [string lowercaseString];
    if([string isEqualToString:@"style"])
        return IJSVGNodeTypeStyle;
    if([string isEqualToString:@"switch"])
        return IJSVGNodeTypeSwitch;
    if( [string isEqualToString:@"defs"] )
        return IJSVGNodeTypeDef;
    if( [string isEqualToString:@"g"] )
        return IJSVGNodeTypeGroup;
    if( [string isEqualToString:@"path"] )
        return IJSVGNodeTypePath;
    if( [string isEqualToString:@"polygon"] )
        return IJSVGNodeTypePolygon;
    if( [string isEqualToString:@"polyline"] )
        return IJSVGNodeTypePolyline;
    if( [string isEqualToString:@"rect"] )
        return IJSVGNodeTypeRect;
    if( [string isEqualToString:@"line"] )
        return IJSVGNodeTypeLine;
    if( [string isEqualToString:@"circle"] )
        return IJSVGNodeTypeCircle;
    if( [string isEqualToString:@"ellipse"] )
        return IJSVGNodeTypeEllipse;
    if( [string isEqualToString:@"use"] )
        return IJSVGNodeTypeUse;
    if( [string isEqualToString:@"lineargradient"] )
        return IJSVGNodeTypeLinearGradient;
    if( [string isEqualToString:@"radialgradient"] )
        return IJSVGNodeTypeRadialGradient;
    if( [string isEqualToString:@"glyph"] )
        return IJSVGNodeTypeGlyph;
    if( [string isEqualToString:@"font"] )
        return IJSVGNodeTypeFont;
    if( [string isEqualToString:@"clippath"] )
        return IJSVGNodeTypeClipPath;
    if( [string isEqualToString:@"mask"] )
        return IJSVGNodeTypeMask;
    if( [string isEqualToString:@"image"] )
        return IJSVGNodeTypeImage;
    if([string isEqualToString:@"pattern"])
        return IJSVGNodeTypePattern;
    if([string isEqualToString:@"svg"])
        return IJSVGNodeTypeSVG;
    if([string isEqualToString:@"text"])
        return IJSVGNodeTypeText;
    if([string isEqualToString:@"tspan"] || kind == NSXMLTextKind) {
        return IJSVGNodeTypeTextSpan;
    }
    return IJSVGNodeTypeNotFound;
}

- (id)init
{
    if( ( self = [self initWithDef:YES] ) != nil )
    {
    }
    return self;
}

- (void)applyPropertiesFromNode:(IJSVGNode *)node
{
    self.name = node.name;
    self.type = node.type;
    self.unicode = node.unicode;
    self.className = node.className;
    self.classNameList = node.classNameList;
    
    self.x = node.x;
    self.y = node.y;
    self.width = node.width;
    self.height = node.height;
    
    self.fillGradient = node.fillGradient;
    self.fillPattern = node.fillPattern;
    self.strokeGradient = node.strokeGradient;
    self.strokePattern = node.strokePattern;
    
    self.fillColor = node.fillColor;
    self.strokeColor = node.strokeColor;
    self.clipPath = node.clipPath;
    
    self.units = node.units;
    self.contentUnits = node.contentUnits;
    
    self.opacity = node.opacity;
    self.strokeWidth = node.strokeWidth;
    self.fillOpacity = node.fillOpacity;
    self.strokeOpacity = node.strokeOpacity;
    
    self.identifier = node.identifier;
    self.usesDefaultFillColor = node.usesDefaultFillColor;
    
    self.transforms = node.transforms;
    self.def = node.def;
    self.windingRule = node.windingRule;
    self.lineCapStyle = node.lineCapStyle;
    self.lineJoinStyle = node.lineJoinStyle;
    self.parentNode = node.parentNode;
    
    self.shouldRender = node.shouldRender;
    self.blendMode = node.blendMode;
    
    // dash array needs physical memory copied
    CGFloat * nStrokeDashArray = (CGFloat *)malloc(node.strokeDashArrayCount*sizeof(CGFloat));
    memcpy( self.strokeDashArray, nStrokeDashArray, node.strokeDashArrayCount*sizeof(CGFloat));
    self.strokeDashArray = nStrokeDashArray;
    self.strokeDashArrayCount = node.strokeDashArrayCount;
    self.strokeDashOffset = node.strokeDashOffset;
}

- (id)copyWithZone:(NSZone *)zone
{
    IJSVGNode * node = [[self class] allocWithZone:zone];
    [node applyPropertiesFromNode:self];
    return node;
}

- (id)initWithDef:(BOOL)flag
{
    if( ( self = [super init] ) != nil )
    {
        self.opacity = [IJSVGUnitLength unitWithFloat:0.f];
        self.fillOpacity = [IJSVGUnitLength unitWithFloat:1.f];
        
        self.strokeDashOffset = [IJSVGUnitLength unitWithFloat:0.f];
        self.shouldRender = YES;
        
        self.strokeOpacity = [IJSVGUnitLength unitWithFloat:1.f];
        self.strokeOpacity.inherit = YES;
        
        self.strokeWidth = [IJSVGUnitLength unitWithFloat:0.f];
        self.strokeWidth.inherit = YES;
        
        self.windingRule = IJSVGWindingRuleInherit;
        self.lineCapStyle = IJSVGLineCapStyleInherit;
        self.lineJoinStyle = IJSVGLineJoinStyleInherit;
        self.units = IJSVGUnitInherit;
        
        self.blendMode = IJSVGBlendModeNormal;
        
        if( flag ) {
            self.def = [[IJSVGDef alloc] init];
        }
    }
    return self;
}

- (IJSVGDef *)defForID:(NSString *)anID
{
    IJSVGDef * aDef = nil;
    if( (aDef = [self.def defForID:anID]) != nil )
        return aDef;
    if( self.parentNode != nil )
        return [self.parentNode defForID:anID];
    return nil;
}

- (void)addDef:(IJSVGNode *)aDef
{
    [self.def addDef:aDef];
}

// winding rule can inherit..
- (IJSVGWindingRule)windingRule
{
    if( _windingRule == IJSVGWindingRuleInherit && self.parentNode != nil ) {
        return self.parentNode.windingRule;
    }
    return _windingRule;
}

- (IJSVGLineCapStyle)lineCapStyle
{
    if( _lineCapStyle == IJSVGLineCapStyleInherit )
    {
        if( self.parentNode != nil )
            return self.parentNode.lineCapStyle;
    }
    return _lineCapStyle;
}

- (IJSVGLineJoinStyle)lineJoinStyle
{
    if( _lineJoinStyle == IJSVGLineJoinStyleInherit )
    {
        if( self.parentNode != nil )
            return self.parentNode.lineJoinStyle;
    }
    return _lineJoinStyle;
}

// these are all recursive, so go up the chain
// if they dont exist on this specific node
- (IJSVGUnitLength *)opacity
{
    if(_opacity.inherit && self.parentNode != nil) {
        return self.parentNode.opacity;
    }
    return _opacity;
}

// these are all recursive, so go up the chain
// if they dont exist on this specific node
- (IJSVGUnitLength *)fillOpacity
{
    if(_fillOpacity.inherit && self.parentNode != nil) {
        return self.parentNode.fillOpacity;
    }
    return _fillOpacity;
}

// these are all recursive, so go up the chain
// if they dont exist on this specific node
- (IJSVGUnitLength *)strokeWidth
{
    if(_strokeWidth.inherit && self.parentNode != nil) {
        return self.parentNode.strokeWidth;
    }
    return _strokeWidth;
}

// these are all recursive, so go up the chain
// if they dont exist on this specific node
- (NSColor *)strokeColor
{
    if( _strokeColor != nil )
        return _strokeColor;
    if( _strokeColor == nil && self.parentNode != nil )
        return self.parentNode.strokeColor;
    return nil;
}

- (IJSVGUnitLength *)strokeOpacity
{
    if(_strokeOpacity.inherit && self.parentNode != nil) {
        return self.parentNode.strokeOpacity;
    }
    return _strokeOpacity;
}

// even though the spec explicity states fill color
// must be on the path, it can also be on the
- (NSColor *)fillColor
{
    if( _fillColor == nil && self.parentNode != nil )
        return self.parentNode.fillColor;
    return _fillColor;
}

// these are all recursive, so go up the chain
// if they dont exist on this specific node
- (IJSVGGradient *)fillGradient
{
    if(_fillGradient == nil && self.parentNode != nil) {
        return self.parentNode.fillGradient;
    }
    return _fillGradient;
}

// these are all recursive, so go up the chain
// if they dont exist on this specific node
- (IJSVGPattern *)fillPattern
{
    if(_fillPattern == nil && self.parentNode != nil) {
        return self.parentNode.fillPattern;
    }
    return _fillPattern;
}

// these are all recursive, so go up the chain
// if they dont exist on this specific node
- (IJSVGGradient *)strokeGradient
{
    if(_strokeGradient == nil && self.parentNode != nil) {
        return self.parentNode.strokeGradient;
    }
    return _strokeGradient;
}

// these are all recursive, so go up the chain
// if they dont exist on this specific node
- (IJSVGPattern *)strokePattern
{
    if(_strokePattern == nil && self.parentNode != nil) {
        return self.parentNode.strokePattern;
    }
    return _strokePattern;
}

@end
