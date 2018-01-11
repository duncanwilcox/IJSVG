//
//  IJSVGCommand.m
//  IconJar
//
//  Created by Curtis Hard on 30/08/2014.
//  Copyright (c) 2014 Curtis Hard. All rights reserved.
//

#import "IJSVGCommand.h"
#import "IJSVGUtils.h"

@interface IJSVGCommand ()
//    NSString * commandString;
//    NSString * command;
//    CGFloat * parameters;
//    NSInteger parameterCount;
//    NSMutableArray * subCommands;
//    NSInteger requiredParameters;
//    IJSVGCommandType type;
//    IJSVGCommand * __weak previousCommand;
//    Class<IJSVGCommandProtocol> commandClass;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation IJSVGCommand

static NSMutableDictionary * _classes = nil;

- (void)dealloc
{
    free(self.parameters);
}

- (id)initWithCommandString:(NSString *)str
{
    if( ( self = [super init] ) != nil )
    {
        // work out the basics
        self.currentIndex = 0;
        self.subCommands = [[NSMutableArray alloc] init];
        self.command = [[str substringToIndex:1] copy];
        self.type = [IJSVGUtils typeForCommandString:self.command];
        self.commandClass = [[self class] commandClassForCommandLetter:self.command];
        NSInteger cnt = 0;
        self.parameters = [IJSVGUtils commandParameters:str count:&cnt];
        self.parameterCount = cnt;
        self.requiredParameters = [self.commandClass requiredParameterCount];
        
        // now work out the sets of parameters we have
        // each command could have a series of subcommands
        // if there is a multiple of commands in a command
        // then we need to work those out...
        NSInteger sets = 1;
        if( self.requiredParameters != 0 ) {
            sets = self.parameterCount/self.requiredParameters;
        }
        
        // interate over the sets
        for( NSInteger i = 0; i < sets; i++ ) {
            // memory for this will be handled by the created subcommand
            CGFloat * subParams = 0;
            if( self.requiredParameters != 0 ) {
                subParams = (CGFloat*)malloc(self.requiredParameters*sizeof(CGFloat));
                for( NSInteger p = 0; p < self.requiredParameters; p++ ) {
                    subParams[p] = self.parameters[i*self.requiredParameters+p];
                }
            }
            
            // create a subcommand per set
            IJSVGCommand * c = [[[self class] alloc] init];
            c.parameterCount = self.requiredParameters;
            c.parameters = subParams;
            c.type = self.type;
            c.command = self.command;
            c.previousCommand = [self.subCommands lastObject];
            c.commandClass = self.commandClass;
            
            // add it to our tree
            [self.subCommands addObject:c];
        }
    }
    return self;
}

+ (NSPoint)readCoordinatePair:(CGFloat *)pairs
                        index:(NSInteger)index
{
    return NSMakePoint( pairs[index*2], pairs[index*2+1]);
}

+ (void)registerClass:(Class)aClass
           forCommand:(NSString *)command
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _classes = [[NSMutableDictionary alloc] init];
    });
    [_classes setObject:NSStringFromClass(aClass)
                 forKey:command];
}

+ (NSDictionary *)registeredCommandClasses
{
    return _classes;
}

+ (void)load
{
    // register here...
}

+ (Class<IJSVGCommandProtocol>)commandClassForCommandLetter:(NSString *)str
{
    NSString * command = nil;
    if( ( command = [_classes objectForKey:[str lowercaseString]] ) == nil )
        return nil;
    return NSClassFromString(command);
}

- (CGFloat)readFloat
{
    CGFloat f = self.parameters[self.currentIndex];
    self.currentIndex++;
    return f;
}

- (NSPoint)readPoint
{
    CGFloat x = self.parameters[self.currentIndex];
    CGFloat y = self.parameters[self.currentIndex+1];
    self.currentIndex+=2;
    return NSMakePoint( x, y );
}

- (BOOL)readBOOL
{
    return [self readFloat] == 1;
}

- (void)resetRead
{
    _currentIndex = 0;
}

@end
