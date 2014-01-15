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

static const double LONG_PRESS_TIMEOUT = 0.50; // Time needed to calibrate
#define TOTAL_FINGERS 4 // Number of fingers needed to calibrate

@interface InputViewController() {
    __weak IBOutlet UILabel *label; // Stores the current text typed on the screen
    Input *lookup;
}

@property (weak, nonatomic) IBOutlet InputView *inputView;

@end

@implementation InputViewController

// This method is called when the user has been holding his or her fingers for more than 1s.
// The screen is calibrated with the current touch events if and only if there are 4 fingers down.
- (void)onLongPress {
    if ([_curTouches count] == TOTAL_FINGERS) {
         NSLog(@"Long Press");
        [self.inputView setCalibrationPoints:_curTouches]; // Draw the calibration points
        [_interpreter interpretLongPress:[self convertToTouchPoints:_curTouches]];
        _curString = nil; // Erase the current touch
        _touchHandled = YES; // Touch has been handled (Don't interpret twice)
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"Calibrated");
    }
}

// This method is called when the user adds a finger to the screen (may or may not be the first one down).
// If the previous touch has been handled (always should be) then reset the touch handled and update the
// current fingers on the screen. If there are already fingers down on the screen (touchHandled == true)
// then add the new touches to the set of fingers on the screen. Always reset the timer if a new touch began.
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    [label setText:@""];
    if (_touchHandled) { // Previous touch event 
        NSLog(@"Touches began: %d", [touches count]);
        _touchHandled = NO;
        _curTouches = touches;
    } else { // One or more fingers are already down on the screen
        for (UITouch *touch in touches) { // Update currentTouches
            [_curTouches addObject:touch];
        }
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(onLongPress) object:nil];
    [self performSelector:@selector(onLongPress) withObject:nil afterDelay:LONG_PRESS_TIMEOUT];
}

// This method is called when the user's fingers move on the screen (NOT when a new touch down occurs).
// If the touch has not been handled and there are atleast as many fingers down as before, then update
// the current touches and redraw them to the screen.
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!_touchHandled && [touches count] >= [_curTouches count]) {
        //NSLog(@"Touches Updated: %d touches", [touches count]);
        [self.inputView setPoints:touches]; // Redraw white circles
        _curTouches = touches;
    }
}

// This method is called when the user's fingers are lifted from the screen. Cancel the timer so the
// calibration points are not updated. Updates current touches if there are atleast as many fingers
// down as before. Interprets the touch events if they have not been already and updates the label
// to display the layout that represents the touch event.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(onLongPress) object:nil];
    if (!_touchHandled) {
        if ([touches count] >= [_curTouches count]) {
            _curTouches = touches;
        }
        NSMutableString *input = [_interpreter interpretShortPress:[self convertToTouchPoints:_curTouches]];
        if (_curString != nil) { // 2nd Touch
            input = [NSMutableString stringWithFormat:@"%@%@", _curString, input];
            _curString = [lookup getCharacter:input]; // Convert the character
    
            if (_curString != nil) {
                [label setText:_curString]; // Update label's text
                if ([_curString isEqualToString:@" "]) {
                    [label setText:@"SPACE"];
                }
                if (![_curString isEqualToString:@"CAPITAL"] && ![_curString isEqualToString:@"NUMBER"]) {
                    ViewController *defaultView = [self.tabBarController.viewControllers objectAtIndex:0];
     
                    if ([_curString isEqualToString:@"BACKSPACE"]) {
                        _curString = defaultView.textField.text;
                        if (_curString.length > 0) {
                            [label setText:[NSString stringWithFormat:@"Deleted %@", [self getWordForPunctuation:[_curString characterAtIndex:_curString.length - 1]]]];
                            [defaultView.textField setText:[NSString stringWithFormat:@"%@", [_curString substringToIndex:_curString.length - 1]]];
                        }
                    } else {
                        NSString *previous = [NSString stringWithFormat:@"%c", [defaultView.textField.text characterAtIndex:defaultView.textField.text.length - 1]];
                        if ([input isEqualToString:@"01100010"] && previous.length > 0 && ![previous isEqualToString:@" "]) {
                            _curString = @"?";
                            [label setText:@"?"];
                        }
                        if ([input isEqualToString:@"01100110"] && previous.length > 0 && ![previous isEqualToString:@" "]) {
                            _curString = @")";
                            [label setText:@")"];
                        }
                        [defaultView.textField setText:[NSString stringWithFormat:@"%@%@", defaultView.textField.text, _curString]];
                    }
                }
                _curString = nil;
            } else {
                [label setText:@"Invalid Code"];
            }
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, label.text);
        } else { // 1st Touch
            _curString = input;
        }
        _touchHandled = YES;
    }
    NSLog(@"Touch ended: %d touches", [_curTouches count]);
    [self.inputView setPoints:_curTouches];
}

// Returns the word form of the punctuation
- (NSString*)getWordForPunctuation:(char)deleted {
    if (deleted == ' ') {
        return @"Space";
    } else if (deleted == ',') {
        return @"Comma";
    } else if (deleted == ';') {
        return @"Semicolon";
    } else if (deleted == '\'') {
        return @"Apostrophe";
    } else if (deleted == ':') {
        return @"Colon";
    } else if (deleted == '-') {
        return @"Hyphen";
    } else if (deleted == '.') {
        return @"Period";
    } else if (deleted == '!') {
        return @"Exclamation Point";
    } else if (deleted == '\"') {
        return @"Quotation Mark";
    } else if (deleted == ')') {
        return @"Right Paren";
    } else if (deleted == '(') {
        return @"Left Paren";
    }
    return [NSString stringWithFormat:@"%c", deleted];
}

// Returns an NSMutableArray of TouchPoint objects that are made from the UITouch points in touches.
// Call this method on the current touches before the set is passed to the interpreter so that the
// coordinates do not change from the switching of views.
- (NSMutableArray*)convertToTouchPoints:(NSSet*)touches {
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:[_curTouches count]];
    for (UITouch* point in touches) {
        TouchPoint *touch = [[TouchPoint alloc] init];
        touch.x = [point locationInView:self.view].x;
        touch.y = [point locationInView:self.view].y;
        [points addObject:touch];
    }
    return points;
}

// Switches back to the default view if the current view is portrait
- (IBAction)swipeGesture:(id)sender {
    if (!UIDeviceOrientationIsLandscape(self.interfaceOrientation)) {
        [self switchToDefaultView:nil];
    }
}

// Switches the app to the default view controller (index 0). 
- (IBAction)switchToDefaultView:(id)sender {
    self.tabBarController.selectedIndex = 0;
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"Default View");
}

// When the user changes the device to a landscape orientation from this view controller, redraw the circles
// in the view to be their updated position after the rotation. If the user changes the device to portrait,
// switch to the default view controller.
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)) {
        [self switchToDefaultView:self];
    } else {
        _curTouches = nil;
        _curString = nil;
        _touchHandled = YES;
        [self.tabBarController.tabBar setHidden:NO];
        [self.inputView redraw];
    }
}

// Announce to the user which view they are in and update the touch points on the view.
- (void)viewWillAppear:(BOOL)animated {
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"Input View");
    if (!UIDeviceOrientationIsLandscape(self.interfaceOrientation)) {
        [self.tabBarController.tabBar setHidden:YES];
        self.inputView.frame = [UIScreen mainScreen].bounds;
    } else {
        [self.tabBarController.tabBar setHidden:NO];
    }
    [self.inputView redraw];
}

// Before this view controller is switched, the text field in the default view is updated to contain the text
// within the label of this view.
- (void)viewWillDisappear:(BOOL)animated {
    [self.tabBarController.tabBar setHidden:NO];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidUnload {
    label = nil;
    [super viewDidUnload];
}

// Set the input view to support multiple touch events and to allow user interaction. 
- (void)viewDidLoad {
    lookup = [[Input alloc] init];
    self.inputView.multipleTouchEnabled = YES;
    self.inputView.userInteractionEnabled = YES;
    self.inputView.isAccessibilityElement = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    self.inputView.accessibilityTraits = UIAccessibilityTraitAllowsDirectInteraction;
    _touchHandled = YES; // Init to YES so the user can calibrate immediately
    _interpreter = [[Interpreter alloc] init];
}

@end
