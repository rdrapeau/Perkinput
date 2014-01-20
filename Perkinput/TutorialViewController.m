//
//  TutorialViewController.m
//  Perkinput
//
//  Created by Ryan Drapeau on 1/20/14.
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

- (IBAction)switchToDefaultView:(id)sender {
    self.tabBarController.selectedIndex = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBarController.tabBar setHidden:YES];
    self.view.multipleTouchEnabled = YES;
    self.view.userInteractionEnabled = YES;
    self.view.isAccessibilityElement = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    self.view.accessibilityTraits = UIAccessibilityTraitAllowsDirectInteraction;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
