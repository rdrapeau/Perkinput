//
//  Layout.h
//  Perkinput
//
//  Created by Ryan Drapeau on 6/2/13.
//  Copyright (c) 2013 University of Washington. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Layout : NSObject

- (void)setFingerDownAtIndex:(int)index; // Sets the finger down at index in the layout

- (BOOL)isFingerDownAtIndex:(int)index; // Returns whether or not the finger is down at index

- (id)initWithNumFingers:(int)numFingers; // Creates all the layouts possible with the number of fingers

// Returns the error between the calibration points and the touch events
- (double)getErrorForTouches:(NSMutableArray*)touches withCalibrationPoints:(NSMutableArray*)calibrationPoints;

- (NSMutableString*)toString; // Returns the string to display in the label

@end
