//
//  DemographicViewController.m
//  Perkinput
//
//  Created by Ryan Drapeau on 4/15/14.
//  Copyright (c) 2014 University of Washington. All rights reserved.
//

#import "DemographicViewController.h"

@interface DemographicViewController () {
    NSString *ageValue;
    NSString *genderValue;
    NSString *brailleValue;
}

@end

@implementation DemographicViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)ageChange:(id)sender {
    ageValue = [sender titleForSegmentAtIndex:[sender selectedSegmentIndex]];
}

- (IBAction)genderChange:(id)sender {
    genderValue = [sender titleForSegmentAtIndex:[sender selectedSegmentIndex]];
}

- (IBAction)brailleChange:(id)sender {
    brailleValue = [sender titleForSegmentAtIndex:[sender selectedSegmentIndex]];
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

- (IBAction)switchToMainView {
    if (ageValue && genderValue && brailleValue) {
        // LOG HERE
        self.tabBarController.selectedIndex = 0;
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"Default Screen");
    } else {
        UIAlertView* alert;
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select an option for all three questions." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"Demographic Screen");
    ageValue = NULL;
    genderValue = NULL;
    brailleValue = NULL;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait + UIInterfaceOrientationMaskPortraitUpsideDown;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
