//
//  InputViewController.m
//  Perkinput
//
//  Created by Ryan Drapeau on 4/28/13.
//  Copyright (c) 2013 University of Washington. All rights reserved.
//

#import "InputViewController.h"
#import "InputView.h"
#import "Interpreter.h"

static const double LONG_PRESS_TIMEOUT = 0.75; // Time to callibrate
#define TOTAL_FINGERS 4 // Number of fingers needed to calibrate

@interface InputViewController() {

}

@property (weak, nonatomic) IBOutlet InputView *inputView;

@end

@implementation InputViewController

// Callibrate
- (void)onLongPress {
    NSLog(@"Long Press");
    if ([_curTouches count] == TOTAL_FINGERS) {
        _touchHandled = YES;
        [self.inputView setCalibrationPoints:_curTouches];
        // Interpret long press
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"Touches began");
    _touchHandled = NO;
    _touchStart = [event timestamp];
    _curTouches = touches;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(onLongPress) object:nil];
    [self performSelector:@selector(onLongPress) withObject:nil afterDelay:LONG_PRESS_TIMEOUT];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!_touchHandled && [touches count] >= [_curTouches count]) {
        //NSLog(@"Touches Updated: %d touches", [touches count]);
        [self.inputView setPoints:touches];
        _curTouches = touches;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(onLongPress) object:nil];
    if (!_touchHandled && [touches count] >= [_curTouches count]) {
        _curTouches = touches;
        // Interpret short press
    }
    NSLog(@"Touch ended: %d touches", [_curTouches count]);
    [self.inputView setPoints:_curTouches];
}

// Switches the app to the default view controller
- (IBAction)switchToDefaultView:(id)sender {
    self.tabBarController.selectedIndex = 0;
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"Default View");
}

// If the view is in in portrait mode and rotate is on: switch back to default
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)) {
        [self switchToDefaultView:self];
    } else {
        [self.inputView redraw];
    }
}

// Announce to the user which view they are in
- (void)viewWillAppear:(BOOL)animated {
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"Input View");
    [self.inputView redraw];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewDidLoad {
    self.inputView.multipleTouchEnabled = YES;
    self.inputView.userInteractionEnabled = YES;
    _interpreter = [[Interpreter alloc] init];
}

@end
