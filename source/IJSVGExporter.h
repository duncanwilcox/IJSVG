//
//  IJSVGExporter.h
//  IJSVGExample
//
//  Created by Curtis Hard on 06/01/2017.
//  Copyright © 2017 Curtis Hard. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IJSVG;

typedef void (^IJSVGCGPathHandler)(const CGPathElement * pathElement);

void IJSVGExporterPathCaller(void * info, const CGPathElement * pathElement);

typedef NS_OPTIONS( NSInteger, IJSVGExporterOptions) {
    IJSVGExporterOptionNone = 1 << 0,
    IJSVGExporterOptionRemoveUselessGroups = 1 << 1,
    IJSVGExporterOptionRemoveUselessDef = 1 << 2,
    IJSVGExporterOptionMoveAttributesToGroup = 1 << 3,
    IJSVGExporterOptionCreateUseForPaths = 1 << 4,
    IJSVGExporterOptionSortAttributes = 1 << 5,
    IJSVGExporterOptionCollapseGroups = 1 << 6,
    IJSVGExporterOptionCleanupPaths = 1 << 7,
    IJSVGExporterOptionRemoveHiddenElements = 1 << 8,
    IJSVGExporterOptionScaleToSizeIfNecessary = 1 << 9,
    IJSVGExporterOptionCompressOutput = 1 << 10,
    IJSVGExporterOptionCollapseGradients = 1 << 11,
    IJSVGExporterOptionCreateClasses = 1 << 12,
    IJSVGExporterOptionAll = IJSVGExporterOptionRemoveUselessDef|
        IJSVGExporterOptionRemoveUselessGroups|
        IJSVGExporterOptionCreateUseForPaths|
        IJSVGExporterOptionMoveAttributesToGroup|
        IJSVGExporterOptionSortAttributes|
        IJSVGExporterOptionCollapseGroups|
        IJSVGExporterOptionCleanupPaths|
        IJSVGExporterOptionRemoveHiddenElements|
        IJSVGExporterOptionScaleToSizeIfNecessary|
        IJSVGExporterOptionCompressOutput|
        IJSVGExporterOptionCollapseGradients
};

@interface IJSVGExporter : NSObject

@property (nonatomic, copy) NSString * title;

- (id)initWithSVG:(IJSVG *)svg
             size:(CGSize)size
          options:(IJSVGExporterOptions)options;
- (NSString *)SVGString;
- (NSData *)SVGData;

@end
