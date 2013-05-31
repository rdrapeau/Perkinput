//
//  InputViewController.h
//  Perkinput
//
//  Created by Ryan Drapeau on 4/28/13.
//  Copyright (c) 2013 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputViewController : UIViewController {
    BOOL _touchHandled; // Touch has already been handled
    NSSet *_curTouches; // Current fingers on the screen
    NSTimeInterval _touchStart; // Time of the first touch
}

- (IBAction)switchToDefaultView:(id)sender; // Switches to the default view

@end
