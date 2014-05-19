//
//  TutorialViewController.m
//  Perkinput
//
//  Created by Ryan Drapeau on 1/26/14.
//  Copyright (c) 2014 University of Washington. All rights reserved.
//

#import "TutorialViewController.h"
#import "InputViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ViewController.h"
#import "InputView.h"
#import "Interpreter.h"
#import "TouchPoint.h"
#import "Validator.h"

static const double LONG_PRESS_TIMEOUT = 0.50; // Time needed to calibrate
static NSString *const calibratedAnnouncement = @"Calibrated.";
static NSString *const tutorialScreenAnnouncement = @"Entering tutorial screen.";
#define TOTAL_FINGERS 4 // Number of fingers needed to calibrate

@interface TutorialViewController() {
    __weak IBOutlet UILabel *label; // Stores the current text typed on the screen
    Input *lookup;
    Validator *valid;
}

@property (weak, nonatomic) IBOutlet InputView *inputView;

@end

@implementation TutorialViewController

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
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, calibratedAnnouncement);
    }
}

// This method is called when the user adds a finger to the screen (may or may not be the first one down).
// If the previous touch has been handled (always should be) then reset the touch handled and update the
// current fingers on the screen. If there are already fingers down on the screen (touchHandled == true)
// then add the new touches to the set of fingers on the screen. Always reset the timer if a new touch began.
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    [label setText:@""];
    if (_touchHandled) { // Previous touch event
        NSLog(@"Touches began: %tu", [touches count]);
        _touchHandled = NO;
        _curTouches = (NSMutableSet*) touches;
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
        _curTouches = (NSMutableSet*) touches;
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
            _curTouches = (NSMutableSet*) touches;
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
                    if ([_curString isEqualToString:@"BACKSPACE"]) {
                        _curString = _curSequence;
                        if (_curString.length > 0) {
                            [label setText:[NSString stringWithFormat:@"Deleted %@", [self getWordForPunctuation:[_curString characterAtIndex:_curString.length - 1]]]];
                            _curSequence = [NSString stringWithFormat:@"%@", [_curSequence substringToIndex:_curSequence.length - 1]];
                        }
                    } else {
                        NSString *previous = [NSString stringWithFormat:@"%c", [_curSequence characterAtIndex:_curSequence.length - 1]];
                        if ([input isEqualToString:@"01100010"] && previous.length > 0 && ![previous isEqualToString:@" "]) {
                            _curString = @"?";
                            [label setText:@"?"];
                        }
                        if ([input isEqualToString:@"01100110"] && previous.length > 0 && ![previous isEqualToString:@" "]) {
                            _curString = @")";
                            [label setText:@")"];
                        }
                        _curSequence = [NSMutableString stringWithFormat:@"%@%@", _curSequence, _curString];
                    }
                }
                _curString = nil;
            } else {
                [label setText:@"Invalid Code"];
            }
            NSLog(@"%@", [input substringFromIndex:4]);
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, label.text);
        } else { // 1st Touch
            NSLog(@"%@", input);
            if ([self.inputView isCalibrated]) {
                [[UIDevice currentDevice] playInputClick];
            }
            _curString = input;
        }
        _touchHandled = YES;
    }
    NSLog(@"Touch ended: %lu touches", (unsigned long)[_curTouches count]);
    [self.inputView setPoints:_curTouches];
}

// Three Finger Swipe
- (IBAction)fingerSwipe:(id)sender {
    [self switchToDefaultView:self];
}

// Returns the word for the given character / punctuation
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
        return @"Exclamation Mark";
    } else if (deleted == '\"') {
        return @"Quotation Mark";
    } else if (deleted == ')') {
        return @"Right Paren";
    } else if (deleted == '(') {
        return @"Left Paren";
    } else if (deleted == '?') {
        return @"Question Mark";
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

// Switches the app to the default view controller (index 0).
- (IBAction)switchToDefaultView:(id)sender {
    self.tabBarController.selectedIndex = 0;
}

// When the user changes the device to a landscape orientation from this view controller, redraw the circles
// in the view to be their updated position after the rotation. If the user changes the device to portrait,
// switch to the default view controller.
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)) {
        [self switchToDefaultView:self];
    } else {
        [self setUp];
    }
}

// Announce to the user which view they are in and update the touch points on the view.
- (void)viewWillAppear:(BOOL)animated {
    [self setUp];
}

- (void)viewDidAppear:(BOOL)animated {
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, tutorialScreenAnnouncement);
}

// Resets the View
- (void)setUp {
    _curString = nil;
    _curSequence = @"";
    _touchHandled = YES;
    [_interpreter clearCalibrationPoints];
    [label setText:@"Calibrate"];
    [self.inputView reset];
    [self.inputView redraw];
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
    [self performSelectorInBackground:@selector(loadLookupTable) withObject:nil];
    self.inputView.multipleTouchEnabled = YES;
    self.inputView.userInteractionEnabled = YES;
    self.inputView.isAccessibilityElement = YES;
    self.inputView.autoresizesSubviews = YES;
    self.inputView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self setNeedsStatusBarAppearanceUpdate];
    self.inputView.accessibilityTraits = UIAccessibilityTraitAllowsDirectInteraction;
    [self setUp];
}

- (void)loadLookupTable {
    lookup = [[Input alloc] init];
    _interpreter = [[Interpreter alloc] init];
    valid = [Validator getInstance];
}

@end

