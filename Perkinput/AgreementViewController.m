//
//  AgreementViewController.m
//  Perkinput
//
//  Created by Ryan Drapeau on 3/31/14.
//  Copyright (c) 2014 University of Washington. All rights reserved.
//

#import "AgreementViewController.h"

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
    [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:@"http://perkinput.cs.washington.edu/"]];
}

// Switches the app to the default view controller (index 0).
- (IBAction)switchToAgreementView:(id)sender {
    self.tabBarController.selectedIndex = 4;
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"Demographic Screen");
}

- (void)viewWillAppear:(BOOL)animated {
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"Agreement Screen");
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
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [self.agreementView setContentSize:CGSizeMake(screenRect.size.width, 1000)];
    [self.agreementView setScrollEnabled:YES];
    [self.agreementView setPagingEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
