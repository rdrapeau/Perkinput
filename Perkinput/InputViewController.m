//
//  InputViewController.m
//  Perkinput
//
//  Created by Ryan Drapeau on 4/28/13.
//  Copyright (c) 2013 University of Washington. All rights reserved.
//

#import "InputViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ViewController.h"
#import "InputView.h"
#import "Interpreter.h"
#import "TouchPoint.h"

static const double LONG_PRESS_TIMEOUT = 1.0; // Time to callibrate
#define TOTAL_FINGERS 4 // Number of fingers needed to calibrate

@interface InputViewController() {
    __weak IBOutlet UILabel *label;
}

@property (weak, nonatomic) IBOutlet InputView *inputView;

@end

@implementation InputViewController

// Callibrate
- (void)onLongPress {
    if ([_curTouches count] == TOTAL_FINGERS) {
         NSLog(@"Long Press");
        _touchHandled = YES;
        [self.inputView setCalibrationPoints:_curTouches];
        [_interpreter interpretLongPress:[self convertToTouchPoints:_curTouches]];
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate); // Vibrate the phone
    }
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
    if (_touchHandled) {
        NSLog(@"Touches began: %d", [touches count]);
        _touchHandled = NO;
        _touchStart = [event timestamp];
        _curTouches = touches;
    } else {
        for (UITouch *touch in touches) {
            [_curTouches addObject:touch];
           // NSLog(@"Added touch");
        }
    }
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
    if (!_touchHandled) {
        if ([touches count] >= [_curTouches count]) {
            _curTouches = touches;
        }
        NSMutableString *input = [_interpreter interpretShortPress:[self convertToTouchPoints:_curTouches]];
        [label setText:input];
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, input);
        _touchHandled = YES;
    }

    NSLog(@"Touch ended: %d touches", [_curTouches count]);
    [self.inputView setPoints:_curTouches];
}

// Converts the set of touch event objects to be a NSMutableArray of TouchPoint objects
- (NSMutableArray*)convertToTouchPoints:(NSSet*)touches {
    NSMutableArray *unsorted = [NSMutableArray arrayWithCapacity:[_curTouches count]];
    for (UITouch* point in touches) {
        TouchPoint *touch = [[TouchPoint alloc] init];
        touch.x = [point locationInView:self.view].x;
        touch.y = [point locationInView:self.view].y;
        [unsorted addObject:touch];
    }
    return unsorted;
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

// Update the text in the text field to contain the label's text
- (void)viewWillDisappear:(BOOL)animated {
    ViewController *defaultView = [self.tabBarController.viewControllers objectAtIndex:0];
    [defaultView.textField setText:label.text];
}

- (void)viewDidUnload {
    label = nil;
    [super viewDidUnload];
}

- (void)viewDidLoad {
    self.inputView.multipleTouchEnabled = YES;
    self.inputView.userInteractionEnabled = YES;
    _touchHandled = YES;
    _interpreter = [[Interpreter alloc] init];
}

@end
