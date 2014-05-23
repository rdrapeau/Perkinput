//
//  SettingsViewController.m
//  Perkinput
//
//  Created by Ryan Drapeau on 5/23/14.
//  Copyright (c) 2014 University of Washington. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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

- (IBAction)moreInfo:(id)sender {
    [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:@"http://perkinput.cs.washington.edu/"]];
}

- (IBAction)switchToMainScreen:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, @"Entering settings view");
}


@end
