//
//  IJSVGGroup.m
//  IconJar
//
//  Created by Curtis Hard on 30/08/2014.
//  Copyright (c) 2014 Curtis Hard. All rights reserved.
//

#import "IJSVGGroup.h"

@interface IJSVGGroup ()
@property (nonatomic, strong) NSMutableArray *childrenInternal;
@end

@implementation IJSVGGroup

- (id)init
{
    if( ( self = [super init] ) != nil )
    {
        self.childrenInternal = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)prepareFromCopy
{
    self.childrenInternal = [[NSMutableArray alloc] init];
}

- (id)copyWithZone:(NSZone *)zone
{
    IJSVGGroup * node = [super copyWithZone:zone];
    [node prepareFromCopy];
    
    for( __strong IJSVGNode * childNode in self.childrenInternal )
    {
        childNode = [childNode copy];
        childNode.parentNode = node;
        [node addChild:childNode];
    }
    return node;
}

- (void)purgeChildren
{
    [self.childrenInternal removeAllObjects];
}

- (void)addChild:(id)child
{
    if( child != nil )
        [self.childrenInternal addObject:child];
}

- (NSArray *)children
{
    return self.childrenInternal;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@",[super description],self.childrenInternal];
}

@end
