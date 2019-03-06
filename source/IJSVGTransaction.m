//
//  IJSVGTransaction.m
//  IconJar
//
//  Created by Curtis Hard on 11/01/2017.
//  Copyright © 2017 Curtis Hard. All rights reserved.
//

#import "IJSVGTransaction.h"
#import <QuartzCore/QuartzCore.h>

void IJSVGBeginTransactionLock() {
    [CATransaction begin];
    if(@available(macOS 10.14, *)) {} else {
        [CATransaction lock];
    }
    [CATransaction setDisableActions:YES];
};

void IJSVGEndTransactionLock() {
    if(@available(macOS 10.14, *)) {} else {
        [CATransaction unlock];
    }
    [CATransaction commit];
};

void IJSVGObtainTransactionLock(dispatch_block_t block, BOOL renderOnMainThread)
{
    IJSVGBeginTransactionLock();
    if(renderOnMainThread) {
        dispatch_sync(dispatch_get_main_queue(), block);
    } else {
        block();
    }
    IJSVGEndTransactionLock();
};
