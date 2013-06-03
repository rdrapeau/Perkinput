//
//  InputView.h
//  Perkinput
//
//  Created by Ryan Drapeau on 5/27/13.
//  Copyright (c) 2013 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputView : UIView {
    NSSet *points;
    NSSet *calibrationPoints;
}

- (void)setCalibrationPoints:(NSSet*)touches;
- (void)setPoints:(NSSet*)touches;
- (void)redraw;

@end
