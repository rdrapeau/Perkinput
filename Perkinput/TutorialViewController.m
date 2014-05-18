//
//  TutorialViewController.m
//  Perkinput
//
//  Created by Ryan Drapeau on 1/26/14.
//  Copyright (c) 2014 University of Washington. All rights reserved.
//

#import "TutorialViewController.h"

static NSString *const tutorialScreenAnnouncement = @"Entering tutorial screen";

@interface TutorialViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *tutorialView;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Launches the Perkinput site
- (IBAction)moreInfo:(id)sender {
    [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:@"http://perkinput.cs.washington.edu/"]];
}

// Switches the app to the default view controller (index 0).
- (IBAction)switchToDefaultView:(id)sender {
    self.tabBarController.selectedIndex = 0;
}

// Switches to the input view controller (index 1) and announces the change to the user.
- (IBAction)switchToInputView:(id)sender {
    self.tabBarController.selectedIndex = 1;
}

- (void)viewWillAppear:(BOOL)animated {
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, tutorialScreenAnnouncement);
}

- (void)viewDidAppear:(BOOL)animated {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [self.tutorialView setContentSize:CGSizeMake(screenRect.size.width, 1828)];
    [self.tutorialView setScrollEnabled:YES];
    [self.tutorialView setPagingEnabled:NO];
}

@end
