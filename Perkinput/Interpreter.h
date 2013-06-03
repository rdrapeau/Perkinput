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

- (Input *)interpretLongPress:(NSSet *)touches;
- (Input *)interpretShortPress:(NSSet *)touches;
- (void) calibrateWithPoints:(NSSet *)touches;

@end
