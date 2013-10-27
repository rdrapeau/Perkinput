//
//  InputViewController.h
//  Perkinput
//
//  Created by Ryan Drapeau on 4/28/13.
//  Copyright (c) 2013 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Interpreter.h"

@interface InputViewController : UIViewController {
    BOOL _touchHandled; // Whether the touch has already been handled or not
    NSMutableSet *_curTouches; // Current touch events on the screen
    NSString *_curString; // Current code being typed
    Interpreter *_interpreter; // Convert the touch to a layout
}

@end
