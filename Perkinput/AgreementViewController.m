//
//  AgreementViewController.m
//  Perkinput
//
//  Created by Ryan Drapeau on 3/31/14.
//  Copyright (c) 2014 University of Washington. All rights reserved.
//

#import "AgreementViewController.h"

static NSString *const agreementScreenAnnouncement = @"Entering agreement screen";

@interface AgreementViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *agreementView;

@end

@implementation AgreementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Launches the Perkinput site
- (IBAction)moreInfo:(id)sender {
    [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:@"https://groups.google.com/forum/#!forum/mobileaccessibility"]];
}

- (IBAction)switchToAgreementView:(id)sender {
    self.tabBarController.selectedIndex = 4;
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait + UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, agreementScreenAnnouncement);
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [self.agreementView setContentSize:CGSizeMake(screenRect.size.width, 1000)];
    [self.agreementView setScrollEnabled:YES];
    [self.agreementView setPagingEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
