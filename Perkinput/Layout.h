//
//  Layout.h
//  Perkinput
//
//  Created by Ryan Drapeau on 6/2/13.
//  Copyright (c) 2013 University of Washington. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Layout : NSObject

- (void)setFingerDownAtIndex:(int)index;
- (BOOL)isFingerDownAtIndex:(int)index;
- (id)initWithNumFingers:(int)numFingers;
- (double)getErrorForTouches:(NSMutableArray*)touches withCalibrationPoints:(NSMutableArray*)calibrationPoints;

@end
