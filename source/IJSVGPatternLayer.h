//
//  IJSVGPatternLayer.h
//  IJSVGExample
//
//  Created by Curtis Hard on 07/01/2017.
//  Copyright © 2017 Curtis Hard. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "IJSVGLayer.h"
#import "IJSVGPattern.h"

@interface IJSVGPatternLayer : IJSVGLayer

@property (nonatomic, strong) IJSVGLayer * pattern;
@property (nonatomic, strong) IJSVGPattern * patternNode;

@end
