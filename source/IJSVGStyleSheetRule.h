//
//  IJSVGStyleSheetRule.h
//  IJSVGExample
//
//  Created by Curtis Hard on 16/01/2016.
//  Copyright © 2016 Curtis Hard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IJSVGStyleSheetSelector.h"
#import "IJSVGStyle.h"

@class IJSVGNode;

@interface IJSVGStyleSheetRule : NSObject

@property (nonatomic, strong) NSArray *selectors;
@property (nonatomic, strong) IJSVGStyle *style;

- (BOOL)matchesNode:(IJSVGNode *)node
           selector:(IJSVGStyleSheetSelector **)matchedSelector;

@end
