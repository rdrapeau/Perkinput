//
//  Interpreter.h
//  Perkinput
//
//  Created by Ryan Drapeau on 6/2/13.
//  Copyright (c) 2013 University of Washington. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Input.h"

// Number of points needed to calibrate
#define TOTAL_FINGERS 4

@class Input;

@interface Interpreter : NSObject {
    BOOL _inLandscape;
    NSMutableDictionary* _layouts;
}

- (void)interpretLongPress:(NSMutableArray*)touches;

- (NSMutableString*)interpretShortPress:(NSMutableArray*)touches;

- (NSMutableArray*)sortTouches:(NSMutableArray*) touches;

@end
