//
//  DemographicViewController.m
//  Perkinput
//
//  Created by Ryan Drapeau on 4/15/14.
//  Copyright (c) 2014 University of Washington. All rights reserved.
//

#import "DemographicViewController.h"

static NSString *const demographicScreenAnnouncement = @"Entering demographic screen";

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
    [self performSelectorInBackground:@selector(logDemographicEvent) withObject:nil]; // LOG Input
        self.tabBarController.selectedIndex = 0;
    } else {
        UIAlertView* alert;
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select an option for all three questions." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)logDemographicEvent {
    NSString *params = [NSString stringWithFormat:@"event=demographic_event&gender=%@&age=%@&reading_ability=%@", genderValue, ageValue, brailleValue];
    [self logToServer:params];
}

// Sends the log to the server with the params (do not include UUID in params as it is done here)
- (void)logToServer:(NSString*)params {
    NSUUID *uid = [[UIDevice currentDevice] identifierForVendor];
    NSString *param = [NSString stringWithFormat:@"http://staff.washington.edu/drapeau/logger.php?id=%@&%@", [uid UUIDString], params];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:param]];
    NSLog(result);
}

- (void)viewWillAppear:(BOOL)animated {
    ageValue = NULL;
    genderValue = NULL;
    brailleValue = NULL;
}

- (void)viewDidAppear:(BOOL)animated {
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, demographicScreenAnnouncement);
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait + UIInterfaceOrientationMaskPortraitUpsideDown;
}

@end
