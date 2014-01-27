//
//  InputView.h
//  Perkinput
//
//  Created by Ryan Drapeau on 5/27/13.
//  Copyright (c) 2013 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputView : UIView {
    NSSet *points; // Current fingers on the screen
    NSSet *calibrationPoints; // Current calibration layout
}

- (void)setCalibrationPoints:(NSSet*)touches; // Update calibration points

- (void)setPoints:(NSSet*)touches; // Update white circles

- (void)redraw; // Redraw everything on the screen

@end
