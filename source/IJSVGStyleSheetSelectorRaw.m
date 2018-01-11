//
//  IJSVGStyleSheetSelectorRaw.m
//  IJSVGExample
//
//  Created by Curtis Hard on 16/01/2016.
//  Copyright © 2016 Curtis Hard. All rights reserved.
//

#import "IJSVGStyleSheetSelectorRaw.h"

@interface IJSVGStyleSheetSelectorRaw ()
@property (nonatomic, strong) NSMutableArray *classesInternal;
@end

@implementation IJSVGStyleSheetSelectorRaw

- (id)init
{
    if( ( self = [super init] ) != nil )
    {
        self.classesInternal = [[NSMutableArray alloc] init];
        self.combinator = IJSVGStyleSheetSelectorCombinatorDescendant;
        self.combinatorString = @" ";
    }
    return self;
}

- (void)addClassName:(NSString *)className
{
    [self.classesInternal addObject:className];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Combinator: %@, Tag: %@, Classes: %@, Identifier: %@", self.combinatorString, self.tag, self.classesInternal, self.identifier];
}

@end
