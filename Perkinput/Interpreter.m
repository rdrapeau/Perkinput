//
//  Interpreter.m
//  Perkinput
//
//  Created by Ryan Drapeau on 6/2/13.
//  Copyright (c) 2013 University of Washington. All rights reserved.
//

#import "Interpreter.h"
#import "Layout.h"
#import "TouchPoint.h"

@implementation Interpreter {
    NSMutableArray *calibratedPoints;
}

- (id)init {
    // initialize the control character "constants"
    _layouts = [[NSMutableDictionary alloc] init];
    
    // Add the layouts for every possible number of fingers touching the screen.
    for(int i = 0; i < TOTAL_FINGERS; ++i) {
        NSMutableArray* layouts = [self generateLayoutsWithFingersTotal:TOTAL_FINGERS andFingersDown:i];
        [_layouts setObject:layouts forKey:[NSNumber numberWithInt:i]];
    }
    
    return self;
}

- (void)clearCalibrationPoints {
    calibratedPoints = nil;
}

// Calibrates the points according to the 4 points in touches  
- (void)interpretLongPress:(NSMutableArray*)touches {
    if ([touches count] == TOTAL_FINGERS) {
        [self calibrateWithPoints:touches];
    }
}

// Sets the calibration points to the points in touches
- (void)calibrateWithPoints:(NSMutableArray*)touches {
    CGPoint ranges = [self getRange:touches];
    _inLandscape = ranges.y > ranges.x;
    //NSLog(@"Calibrating: %s", _inLandscape ? "Landscape" : "Portrait");
    calibratedPoints = [self sortTouches:touches];
}

// Handles a short press event. Returns a input object storing the layout for this touch.
- (NSMutableString*)interpretShortPress:(NSMutableArray*)touches {
    if (calibratedPoints == nil) { // Screen has not been calibrated with 4 fingers yet
        NSLog(@"Screen has not been calibrated");
        if ([touches count] > 1)
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, [NSString stringWithFormat:@"%d fingers down. Hold 4 fingers down to calibrate", [touches count]]);
        else
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, [NSString stringWithFormat:@"%d finger down. Hold 4 fingers down to calibrate", [touches count]]);
        return nil;
    }
    NSMutableArray *sortedTouches = [self sortTouches:touches];
    
    NSNumber *numFingers = [NSNumber numberWithInt:[touches count]];
    NSMutableArray *layouts = [_layouts objectForKey:numFingers];
    int count = [layouts count];
    
    double minError = DBL_MAX;
    Layout *bestLayout = nil;
    
    for (int i = 0; i < count; i++) {
        Layout *currentLayout = [layouts objectAtIndex:i];
        double error = [currentLayout getErrorForTouches:sortedTouches withCalibrationPoints:calibratedPoints];
        
        if (error < minError) { // Update the best layout
            minError = error;
            bestLayout = currentLayout;
        }
    }    
    return [bestLayout toString];
}

// Returns a sorted array of TouchPoint objects. Sorted by the y value if the device is in
// landscape orientation or by the x value if in portrait orientation.
- (NSMutableArray*)sortTouches:(NSMutableArray*)touches {
    int count = [touches count];
    
    // Convert the touches set to be an Array with TouchPoint wrapper objects
    NSMutableArray *unsorted = [NSMutableArray arrayWithCapacity:[touches count]];
    for (TouchPoint *point in touches) {
        [unsorted addObject:point];
    }
    
    NSMutableArray *sorted = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        int indexOfMin = [self getMinValue:unsorted];
        
        TouchPoint *min = unsorted[indexOfMin];
        [unsorted removeObjectAtIndex:indexOfMin];
        [sorted addObject:min];
    }
    return sorted;
}

// Returns the index of the smallest value in the array
- (int)getMinValue:(NSMutableArray *)array {
    float min = INFINITY;
    int index = -1;
    for (int i = 0; i < [array count]; i++) {
        TouchPoint *point = array[i];
        if (_inLandscape && point.y < min) {
            min = point.y;
            index = i;
        } else if (!_inLandscape && point.x < min) { // Portrait
            min = point.x;
            index = i;
        }
    }
    return index;
}


// Returns an array of possible layouts for the number of fingers down and the total number of fingers
- (NSMutableArray *)generateLayoutsWithFingersTotal:(int)fingersTotal andFingersDown:(int)fingersDown {
    // Base cases
    if (fingersDown == 0) {
        // Return an array with one element, where no fingers are down.
        Layout *layout = [[Layout alloc] initWithNumFingers:fingersTotal];
        return [[NSMutableArray alloc] initWithObjects:layout, nil];
    } else if(fingersTotal == 0) {
        // Return an empty array of layouts.
        return [[NSMutableArray alloc] init];
    }
    
    // Recursive cases
    NSMutableArray* set1Suffixes = [self generateLayoutsWithFingersTotal:(fingersTotal - 1) andFingersDown:fingersDown];
    int set1Length = [set1Suffixes count];
    
    NSMutableArray* set2Suffixes = [self generateLayoutsWithFingersTotal:(fingersTotal - 1) andFingersDown:(fingersDown - 1)];
    int set2Length = [set2Suffixes count];
    
    // Create a new NSMutableArray.
    NSMutableArray* layoutArray = [[NSMutableArray alloc] initWithCapacity:(set1Length + set2Length)];
    
    // Add the first set if syffuxes, where the first position of each layout is NOT down.
    for(int i = 0; i < set1Length; ++i) {
        // Create a new layout (no fingers are down by default).
        Layout *layout = [[Layout alloc] initWithNumFingers:fingersTotal];
        
        // Set each layout position
        for(int pos = 1; pos < fingersTotal; ++pos) {
            if([[set1Suffixes objectAtIndex:i] isFingerDownAtIndex:pos-1]) {
                [layout setFingerDownAtIndex:pos];
            }
        }
        
        // Add the layout to the array of layouts
        [layoutArray addObject:layout];
    }
    
    // Second set. the first position of each layout is DOWN.
    for(int i = 0; i < set2Length; ++i) {
        // Create a new layout and set the first finger down this time.
        Layout *layout = [[Layout alloc] initWithNumFingers:fingersTotal];
        [layout setFingerDownAtIndex:0];
        
        // Set each layout position
        for(int pos = 1; pos < fingersTotal; ++pos) {
            if([[set2Suffixes objectAtIndex:i] isFingerDownAtIndex:pos-1]) {
                [layout setFingerDownAtIndex:pos];
            }
        }
        // Add the layout to the array of layouts
        [layoutArray addObject:layout];
    }
    
    return layoutArray;
}

// Returns a point representing the range in x and in y.
- (CGPoint)getRange:(NSMutableArray*)touches {
    float minY = INFINITY;
    float minX = INFINITY;
    float maxY = 0;
    float maxX = 0;
    
    for (TouchPoint *touch in touches) {
        float x = touch.x;
        float y = touch.y;
        
        if(x < minX) {
            minX = x;
        }
        if(x > maxX) {
            maxX = x;
        }
        if(y < minY) {
            minY = y;
        }
        if(y > maxY) {
            maxY = y;
        }
    }
    return CGPointMake(maxX - minX, maxY - minY);
}

@end
