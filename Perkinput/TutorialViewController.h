//
//  TutorialViewController.h
//  Perkinput
//
//  Created by Ryan Drapeau on 1/26/14.
//  Copyright (c) 2014 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Interpreter.h"

@interface TutorialViewController : UIViewController {
    BOOL _touchHandled; // Whether the touch has already been handled or not
    NSMutableSet *_curTouches; // Current touch events on the screen
    NSString *_curString; // Current code being typed
    NSString *_curSequence; // Current String being typed
    Interpreter *_interpreter; // Convert the touch to a layout
}

@end
