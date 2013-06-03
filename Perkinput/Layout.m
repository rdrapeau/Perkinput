//
//  Layout.m
//  Perkinput
//
//  Created by Ryan Drapeau on 6/2/13.
//  Copyright (c) 2013 University of Washington. All rights reserved.
//

#import "Layout.h"

@implementation Layout {
    int length;
    NSMutableArray *layout;
    UIView *view;
}

// Initializes the layout to contain no fingers down with a specified length
- (id)initWithNumFingers:(int)numFingers withView:(UIView *)currentView {
    self = [super init];
    if (self) {
        length = numFingers;
        layout = [[NSMutableArray alloc] initWithCapacity:length];
        
        for (int i = 0; i < length; i++) { // Initialize the layout with no fingers down
            [layout addObject:[NSNumber numberWithBool:NO]];
        }
        view = currentView;
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
        return [layout objectAtIndex:index];
    } else {
        NSLog(@"Index is out of bounds. Index: %d, Length: %d", index, length);
        return NO;
    }
}

// Returns the difference between each touch and the calibration points
- (double)getErrorForTouches:(NSMutableArray *)touches withCalibrationPoints:(NSMutableArray *)calibrationPoints {
    double error = 0;
    
    for (int i = 0; i < length; i++) {
        CGPoint calibrationPoint = [calibrationPoints[i] locationInView:view];
        if ([self isFingerDownAtIndex:i]) {
            CGPoint inputPoint = [touches[i] locationInView:view];
            int x = calibrationPoint.x - inputPoint.x;
            int y = calibrationPoint.y - inputPoint.y;
            error += x * x + y * y;
        }
    }
    
    return error;
}

@end
