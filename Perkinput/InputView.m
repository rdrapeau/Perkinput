//
//  InputView.m
//  Perkinput
//
//  Created by Ryan Drapeau on 5/27/13.
//  Copyright (c) 2013 University of Washington. All rights reserved.
//

#import "InputView.h"

static const double DIAMETER = 50; // Circle Diameter
static const double CAL_DIAMETER = 85; // Calibration Circle Diameter

@implementation InputView

// Redraws the screen
- (void)redraw {
    [self setNeedsDisplay];
}

// Update the coordinates of the calibration points
- (void)setCalibrationPoints:(NSSet *)touches {
    calibrationPoints = touches;
    NSLog(@"Calibration Points Updated");
    [self setNeedsDisplay];
}

// Update the coordinates of the touch circle
- (void)setPoints:(NSSet*)touches {
    points = touches;
    //NSLog(@"%d touches in setPoints", [points count]);
    [self setNeedsDisplay];
}

// Draws circles where the screen is currently being touched
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 2.0);
    
    for (UITouch* point in calibrationPoints) { // Update calibration circles
        CGContextSetRGBFillColor(ctx, 0.5, 0.5, 1.0, 0.5);
        CGContextSetRGBStrokeColor(ctx, 0, 0, 1.0, 1.0);
        CGRect circlePoint = CGRectMake([point locationInView:self].x - CAL_DIAMETER / 2, [point locationInView:self].y - CAL_DIAMETER / 2, CAL_DIAMETER, CAL_DIAMETER);
        CGContextFillEllipseInRect(ctx, circlePoint);
    }
    
    for (UITouch* point in points) {
        CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
        CGContextSetRGBStrokeColor(ctx, 0, 0, 1.0, 1.0);
        CGRect circlePoint = CGRectMake([point locationInView:self].x - DIAMETER / 2, [point locationInView:self].y - DIAMETER / 2, DIAMETER, DIAMETER);
        CGContextFillEllipseInRect(ctx, circlePoint);
    }
}

- (BOOL)isAccessibilityElement {
    return YES;
}

/* This custom view behaves like a button. */
- (UIAccessibilityTraits)accessibilityTraits {
    return UIAccessibilityTraitAllowsDirectInteraction;
}

@end
