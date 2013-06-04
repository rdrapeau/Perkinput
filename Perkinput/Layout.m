//
//  Layout.m
//  Perkinput
//
//  Created by Ryan Drapeau on 6/2/13.
//  Copyright (c) 2013 University of Washington. All rights reserved.
//

#import "Layout.h"
#import "TouchPoint.h"

@implementation Layout {
    int length;
    NSMutableArray *layout;
}

// Initializes the layout to contain no fingers down with a specified length
- (id)initWithNumFingers:(int)numFingers {
    self = [super init];
    if(self) {
        length = numFingers;
        layout = [[NSMutableArray alloc] initWithCapacity:(numFingers)];
        // Initialize the layout array with no fingers down.
        for(int i = 0; i < numFingers; ++i) {
            [layout addObject:[NSNumber numberWithBool:NO]];
        }
    }
    return self;
}

// Sets the finger down at index within the layout
- (void)setFingerDownAtIndex:(int)index {
    if (index >= 0 && index < length) { // Valid index
        [layout setObject:[NSNumber numberWithBool:YES] atIndexedSubscript:index];
    } else {
        NSLog(@"Index is out of bounds. Index: %d, Length: %d", index, length);
    }
}

// Returns whether or not the finger is down at the index
- (BOOL)isFingerDownAtIndex:(int)index {
    if (index >= 0 && index < length) {
        return [[layout objectAtIndex:index] boolValue]; // YES / NO at the index
    } else {
        NSLog(@"Index is out of bounds. Index: %d, Length: %d", index, length);
        return NO;
    }
}

// Returns the difference between each touch and the calibration points
- (double) getErrorForTouches:(NSMutableArray*)touches withCalibrationPoints:(NSMutableArray*)calibrationPoints {
    int error = 0;
    TouchPoint *callibrationTouch = nil;
    NSEnumerator* cpEnumerator = [calibrationPoints objectEnumerator];
    TouchPoint *inputTouch = nil;
    NSEnumerator* itEnumerator = [touches objectEnumerator];
    
    for(int i = 0; i < length; ++i) {
        callibrationTouch = [cpEnumerator nextObject];
        if([self isFingerDownAtIndex:i]) {
            inputTouch = [itEnumerator nextObject];
            double xError = callibrationTouch.x - inputTouch.x;
            double yError = callibrationTouch.y - inputTouch.y;
            error += xError * xError + yError * yError;
        } 
    }
    
    return error;
}

// Print the layout in a human-readable format. Used for debugging.
- (NSMutableString*) toString {
    NSMutableString* result = [[NSMutableString alloc] init];
    for(int i = 0; i < length; ++i) {
        NSString* touch = @"0";
        if([self isFingerDownAtIndex:i]) {
            touch = @"1";
        }
        [result appendString:touch];
    }
    return result;
}

@end
