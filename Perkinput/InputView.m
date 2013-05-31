//
//  InputView.m
//  Perkinput
//
//  Created by Ryan Drapeau on 5/27/13.
//  Copyright (c) 2013 University of Washington. All rights reserved.
//

#import "InputView.h"
#import "TouchPoint.h"

static const double DIAMETER = 50; // Circle Diameter

@implementation InputView

// Redraws the screen
- (void)redraw {
    [self setNeedsDisplay];
}

// Update the coordinates of the touch circle
- (void)setPoints:(NSSet*)touches {
    points = touches;
    NSLog(@"%d touches in setPoints", [points count]);
    [self setNeedsDisplay];
}

// Draws circles where the screen is currently being touched
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 2.0);
    CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
    CGContextSetRGBStrokeColor(ctx, 0, 0, 1.0, 1.0);
    
    for (UITouch* point in points) {
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
