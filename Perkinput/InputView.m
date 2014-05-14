//
//  InputView.m
//  Perkinput
//
//  Created by Ryan Drapeau on 5/27/13.
//  Copyright (c) 2013 University of Washington. All rights reserved.
//

#import "InputView.h"

static const double DIAMETER = 50; // Touch Point Circle Diameter
static const double CAL_DIAMETER = 85; // Calibration Circle Diameter

@implementation InputView

// Redraws the calibration points and the touch points on the screen.
- (void)redraw {
    [self setNeedsDisplay];
}

// Update the coordinates of the calibration points (bigger dark circles).
- (void)setCalibrationPoints:(NSSet *)touches {
    calibrationPoints = touches;
    [self redraw];
}

// Returns if the calibration points have been set or not
- (BOOL)isCalibrated {
    return calibrationPoints != nil;
}

// Update the coordinates of the touch points (white circles).
- (void)setPoints:(NSSet*)touches {
    points = touches;
    [self redraw];
}

// Resets the points on the screen
- (void)reset {
    calibrationPoints = nil;
    points = nil;
    [self redraw];
}

// Draws all of the touch points and calibration points on the screen.
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 2.0);
    
    if (calibrationPoints && points) {
        for (UITouch* point in calibrationPoints) { // Update calibration circles
            CGContextSetRGBFillColor(ctx, 0.5, 0.5, 1.0, 0.5);
            CGContextSetRGBStrokeColor(ctx, 0, 0, 1.0, 1.0);
            CGRect circlePoint = CGRectMake([point locationInView:self].x - CAL_DIAMETER / 2, [point locationInView:self].y - CAL_DIAMETER / 2, CAL_DIAMETER, CAL_DIAMETER);
            CGContextFillEllipseInRect(ctx, circlePoint);
        }
        
        for (UITouch* point in points) { // Update touch point circles
            CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
            CGContextSetRGBStrokeColor(ctx, 0, 0, 1.0, 1.0);
            CGRect circlePoint = CGRectMake([point locationInView:self].x - DIAMETER / 2, [point locationInView:self].y - DIAMETER / 2, DIAMETER, DIAMETER);
            CGContextFillEllipseInRect(ctx, circlePoint);
        }
    }
}

// This custom view behaves like a button so the user can touch and interact
// with the screen even if VoiceOver is turned on.
- (UIAccessibilityTraits)accessibilityTraits {
    return UIAccessibilityTraitAllowsDirectInteraction;
}

@end
