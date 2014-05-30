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
    BOOL isTutorialMode;
}

- (void)setCalibrationPoints:(NSSet*)touches; // Update calibration points

- (BOOL)isCalibrated;

- (void)setPoints:(NSSet*)touches; // Update white circles

- (void)redraw; // Redraw everything on the screen

- (void)reset; // Resets the points on the screen

- (void)setTutorialMode:(BOOL)isTutorial;

@end
