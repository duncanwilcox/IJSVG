//
//  IJSVGDef.m
//  IJSVGExample
//
//  Created by Curtis Hard on 03/09/2014.
//  Copyright (c) 2014 Curtis Hard. All rights reserved.
//

#import "IJSVGDef.h"

@interface IJSVGDef ()
@property (nonatomic, strong) NSMutableDictionary *dict;
@end

@implementation IJSVGDef

- (id)init
{
    if( ( self = [super initWithDef:NO] ) != nil ) {
        self.dict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addDef:(IJSVGNode *)aDef
{
    if( aDef.identifier == nil ) {
        return;
    }
    [self.dict setObject:aDef
              forKey:aDef.identifier];
}

- (IJSVGDef *)defForID:(NSString *)anID
{
    return [self.dict objectForKey:anID];
}

@end
