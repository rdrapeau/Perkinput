//
//  TutorialViewController.m
//  Perkinput
//
//  Created by Ryan Drapeau on 1/26/14.
//  Copyright (c) 2014 University of Washington. All rights reserved.
//

#import "TutorialViewController.h"
#import "InputViewController.h"
#import "HandViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ViewController.h"
#import "InputView.h"
#import "Interpreter.h"
#import "TouchPoint.h"
#import "Validator.h"

static const double LONG_PRESS_TIMEOUT = 0.50; // Time needed to calibrate
// Swipe three fingers to go back
static NSString *const calibratedAnnouncement = @"The screen is now calibrated.";
static NSString *const tutorialScreenAnnouncement = @"Entering tutorial screen."; // Keep your fingers in the same position
static NSString *const welcomeAnnouncement = @"Welcome to the Perkinput tutorial. Please start by calibrating the screen. Hold down 4 fingers at the same time. To return to the main screen, swipe three fingers to the right."; // Until you hear a sound
static NSString *const enterColumns = @"In Perkinput, enter text by tapping the first column of the braille character followed by the second column. Try entering the letter P which is braille dots 1 2 3 and 4"; // A
static NSString *const enteredP = @"Good! Now let's enter the letter 'A'. 'A' is dot 1 only, so it has a blank second column. Enter dot 8 with your pinky finger to enter the blank column.";
static NSString *const enteredA = @"Good! If you make a mistake, you can enter a backspace. Enter braille dots 1 2 3 4 5 and 6 or double tap the screen with 3 fingers. This will not disable voiceover in the perk input screen. Try deleting the previous letter now.";
static NSString *const closingText = @"This concludes the tutorial, you can return to the main screen by swiping three fingers to the right. When you exit the perk input screen, the text you typed will be in the text field on the main screen. Text in the tutorial is not saved.";
#define TOTAL_FINGERS 4 // Number of fingers needed to calibrate

@interface TutorialViewController() {
    __weak IBOutlet UILabel *label; // Stores the current text typed on the screen
    Input *lookup;
    __weak IBOutlet UILabel *instructionsLabel;
    Validator *valid;
    int state;
    BOOL done;
    /**
     * 0 = pre-calibration
     * 1 = calibrated
     * 2 = p entered
     * 3 = a entered
     * 4 = backspace entered
     */
}

@property (weak, nonatomic) IBOutlet InputView *inputView;
@property (weak, nonatomic) NSTimer *announcementTimer;

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

        if (state < 1) {
            [self stopTimer];
            self.announcementTimer = [NSTimer scheduledTimerWithTimeInterval:25.0 target:self selector:@selector(timerAnnouncement:) userInfo:enterColumns repeats:YES];
            [self announce:[NSString stringWithFormat:@"%@ %@", calibratedAnnouncement, enterColumns]];
            state = 1;
        }
    }
}

// This method is called when the user adds a finger to the screen (may or may not be the first one down).
// If the previous touch has been handled (always should be) then reset the touch handled and update the
// current fingers on the screen. If there are already fingers down on the screen (touchHandled == true)
// then add the new touches to the set of fingers on the screen. Always reset the timer if a new touch began.
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    [self postponeTimer];
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
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hand"] isEqualToString:@"left"]) {
            NSMutableString *reverse = [[NSMutableString alloc] initWithCapacity:[input length]];
            for (int i = [input length] - 1; i >= 0 ; i--) {
                [reverse appendFormat:[NSString stringWithFormat:@"%c", [input characterAtIndex:i]]];
            }
            input = reverse;
        }
        
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
                        if (state == 3) {
                            state = 4;
                            [self stopTimer];
                        }
                        _curString = _curSequence;
                        if (_curString.length > 0) {
                            [label setText:[NSString stringWithFormat:@"Deleted '%@'", [self getWordForPunctuation:[_curString characterAtIndex:_curString.length - 1]]]];
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
            NSString *dots = [self announceBrailleDots:[input substringFromIndex:4] forFirstTap:NO];
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self announceInput:dots];
            
            if (state >= 1) {
                if (state == 1) { // Letter P
                    if ([@"p" isEqualToString:[label text]]) {
                        [self stopTimer];
                        state = 2;
                        [NSObject cancelPreviousPerformRequestsWithTarget:self];
                        [self performSelector:@selector(announce:) withObject:enteredP afterDelay:1.75];
                        [self stopTimer];
                        self.announcementTimer = [NSTimer scheduledTimerWithTimeInterval:25.0 target:self selector:@selector(timerAnnouncement:) userInfo:enteredP repeats:YES];
                    } else {
                        [NSObject cancelPreviousPerformRequestsWithTarget:self];
                        [self performSelector:@selector(announce:) withObject:@"Try entering the letter P to move forward in the tutorial." afterDelay:2.0];
                    }
                } else if (state == 2) {
                    if ([@"a" isEqualToString:[label text]]) {
                        [self stopTimer];
                        state = 3;
                        [NSObject cancelPreviousPerformRequestsWithTarget:self];
                        [self performSelector:@selector(announce:) withObject:enteredA afterDelay:1.75];
                        [self stopTimer];
                        self.announcementTimer = [NSTimer scheduledTimerWithTimeInterval:25.0 target:self selector:@selector(timerAnnouncement:) userInfo:enteredA repeats:YES];
                    } else {
                        [NSObject cancelPreviousPerformRequestsWithTarget:self];
                        [self performSelector:@selector(announce:) withObject:@"Try entering the letter A instead to move forward in the tutorial." afterDelay:1.75];
                    }
                } else if (state == 4 && !done) {
                    done = YES;
                    [NSObject cancelPreviousPerformRequestsWithTarget:self];
                    [self performSelector:@selector(announce:) withObject:closingText afterDelay:2.65];
                    [self stopTimer];
                    self.announcementTimer = [NSTimer scheduledTimerWithTimeInterval:25.0 target:self selector:@selector(timerAnnouncement:) userInfo:closingText repeats:YES];
                }
            }
            
        } else { // 1st Touch
            if ([self.inputView isCalibrated]) {
                [self announceBrailleDots:input forFirstTap:YES];
                [[UIDevice currentDevice] playInputClick];
            }
            _curString = input;
        }
        _touchHandled = YES;
    }
    NSLog(@"Touch ended: %lu touches", (unsigned long)[_curTouches count]);
    [self.inputView setPoints:_curTouches];
}

- (void)announce:(NSString*)announcement {
    [instructionsLabel setText:announcement];
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, announcement);
}

- (void)announceInput:(NSString*)dots {
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, [NSString stringWithFormat:@"%@ , %@", dots, [label.text uppercaseString]]);
}

- (NSString*)announceBrailleDots:(NSString*)input forFirstTap:(BOOL)isFirstTap {
    NSString *announcement = @"Dots ";
    if (![input isEqualToString:@"0001"]) {
        for (NSUInteger i = 0; i < [input length]; i++) {
            if ([input characterAtIndex:i] == '1') {
                int dot = isFirstTap ? i + 1 : i + 4;
                if (!((dot == 4 && isFirstTap) || dot == 7)) {
                    announcement = [NSString stringWithFormat:@"%@%@", announcement, [NSString stringWithFormat:@"%d ", dot]];
                }
            }
        }
    } else {
        if (isFirstTap) {
            announcement = [NSString stringWithFormat:@"%@%@", announcement, @"7"];
        } else {
            announcement = [NSString stringWithFormat:@"%@%@", announcement, @"8"];
        }

    }
    if ([announcement length] < 8) {
        announcement = [NSString stringWithFormat:@"Dot %@", [announcement substringFromIndex:5]];
    }
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, announcement);
    return announcement;
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
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstTime"]) {
        [self performSegueWithIdentifier:@"hand" sender:self];
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(announce:) withObject:welcomeAnnouncement afterDelay:2.0];
        self.announcementTimer = [NSTimer scheduledTimerWithTimeInterval:25.0 target:self selector:@selector(timerAnnouncement:) userInfo:welcomeAnnouncement repeats:YES];
    }
}

- (void)stopTimer {
    if ([self.announcementTimer isValid]) {
        [self.announcementTimer invalidate];
    }
    self.announcementTimer = nil;
}

- (void)timerAnnouncement:(NSTimer*)timer {
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, [timer userInfo]);
}

- (void)postponeTimer {
    if ([self.announcementTimer isValid]) {
        NSString *announcement = [self.announcementTimer userInfo];
        [self stopTimer];
        self.announcementTimer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(timerAnnouncement:) userInfo:announcement repeats:YES];
    }
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
    [self.inputView setTutorialMode:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidUnload {
    label = nil;
    [super viewDidUnload];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self stopTimer];
    state = 0;
}

- (void)viewDidDisappear:(BOOL)animated {
    [self stopTimer];
    state = 0;
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

