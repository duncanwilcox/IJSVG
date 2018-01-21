//
//  IJSVGFontConverter.m
//  IJSVGExample
//
//  Created by Curtis Hard on 21/05/2015.
//  Copyright (c) 2015 Curtis Hard. All rights reserved.
//

#import "IJSVGFontConverter.h"
#import "IJSVGBezierPathAdditions.h"

@interface IJSVGFontConverter ()
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSFont *font;
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *transformedPaths;
@end

@implementation IJSVGFontConverter

- (id)initWithFontAtFileURL:(NSURL *)url
{
    if( ( self = [super init] ) != nil )
    {
        self.url = [url copy];
        
        // load the font
        CGDataProviderRef dataProvider = CGDataProviderCreateWithURL((CFURLRef)self.url);
        CGFontRef fontRef = CGFontCreateWithDataProvider(dataProvider);
        CTFontRef font = CTFontCreateWithGraphicsFont( fontRef, 30.f, NULL, NULL );
        
        // toll free bridge between NSFont at CTFont :)
        self.font = [(__bridge NSFont *)font copy];
        CGFontRelease(fontRef);
        CGDataProviderRelease(dataProvider);
        CFRelease(font);
    }
    return self;
}

- (NSArray *)allCharacters
{
    NSCharacterSet * charSet = self.font.coveredCharacterSet;
    NSMutableArray * array = [[NSMutableArray alloc] init];
    NSStringEncoding encoding = NSUTF32LittleEndianStringEncoding;
    for( int plane = 0; plane <= 16; plane++ ) {
        if( [charSet hasMemberInPlane:plane] ) {
            UTF32Char c;
            for( c = plane << 16; c < (plane+1) << 16; c++ ) {
                if( [charSet longCharacterIsMember:c] ) {
                    UTF32Char c1 = NSSwapHostIntToLittle(c);
                    [array addObject:[[NSString alloc] initWithBytes:&c1
                                                               length:4
                                                             encoding:encoding]];
                }
            }
        }
    }
    return array;
}

- (void)generateMap
{
    CTFontRef font = (__bridge CTFontRef)self.font;
    for( NSString * charString in [self allCharacters] ) {
        // get the characters in each char
        NSUInteger count = charString.length;
        unichar characters[count];
        [charString getCharacters:characters
                            range:NSMakeRange( 0, count )];
        
        // get the glyphs
        CGGlyph glyphs[count];
        CTFontGetGlyphsForCharacters( font, characters, glyphs, count);
        CGPathRef path = CTFontCreatePathForGlyph( font, glyphs[0], NULL );
        if(path != NULL) {
            // add SVG to the dictionary
            NSString * key = [NSString stringWithFormat:@"%04x",[charString characterAtIndex:0]];
            CGPathRef flippedPath = [IJSVGUtils newFlippedCGPath:path];
            self.transformedPaths[key] = (__bridge id)flippedPath;
            CGPathRelease(flippedPath);
        }
        CGPathRelease(path);
    }
}

- (void)enumerateUsingBlock:(IJSVGFontConverterEnumerateBlock)block
{
    if(_transformedPaths == nil) {
        _transformedPaths = [[NSMutableDictionary alloc] init];
        [self generateMap];
    }
    
    for(NSString * key in _transformedPaths.allKeys) {
        block(key, [self.class convertPathToSVG:(CGPathRef)_transformedPaths[key]]);
    }
}

+ (IJSVG *)convertIJSVGPathToSVG:(IJSVGPath *)path
{
    CGPathRef cgPath = [IJSVGUtils newCGPathFromBezierPath:path.path];
    CGPathRef flippedPath = [IJSVGUtils newFlippedCGPath:cgPath];
    IJSVG * svg = [self convertPathToSVG:flippedPath];
    CGPathRelease(flippedPath);
    CGPathRelease(cgPath);
    return svg;
}

+ (IJSVG *)convertPathToSVG:(CGPathRef)path
{
    __block IJSVG * svg = nil;
    IJSVGObtainTransactionLock(^{
        IJSVGGroupLayer * layer = [[IJSVGGroupLayer alloc] init];
        IJSVGShapeLayer * shape = [[IJSVGShapeLayer alloc] init];
        [layer addSublayer:shape];
        shape.path = path;
        CGRect box = CGPathGetPathBoundingBox(path);
        svg = [[IJSVG alloc] initWithSVGLayer:layer
                                      viewBox:box];
    }, NO);
    return svg;
}

@end
