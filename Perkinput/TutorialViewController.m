//
//  TutorialViewController.m
//  Perkinput
//
//  Created by Ryan Drapeau on 1/26/14.
//  Copyright (c) 2014 University of Washington. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (UIDeviceOrientationIsLandscape(self.interfaceOrientation)) {
        [self switchToInputView:self];
    }
}

// Switches the app to the default view controller (index 0).
- (IBAction)switchToDefaultView:(id)sender {
    self.tabBarController.selectedIndex = 0;
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"Default Screen");
}

// Switches to the input view controller (index 1) and announces the change to the user.
- (IBAction)switchToInputView:(id)sender {
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"Input Screen");
    self.tabBarController.selectedIndex = 1;
}

- (void)viewWillAppear:(BOOL)animated {
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"How To Screen");
}

@end
