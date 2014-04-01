//
//  TabViewController.m
//  Perkinput
//
//  Created by Ryan Drapeau on 3/31/14.
//  Copyright (c) 2014 University of Washington. All rights reserved.
//

#import "TabViewController.h"
#import "TutorialViewController.h"
#import "AgreementViewController.h"


@interface TabViewController ()

@end

@implementation TabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)shouldAutorotate {
    if (self.selectedViewController.class == [TutorialViewController class]
            || self.selectedViewController.class == [AgreementViewController class]) {
        return NO;
    }
    return YES;
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
