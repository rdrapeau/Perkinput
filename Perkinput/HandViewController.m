//
//  HandViewController.m
//  Perkinput
//
//  Created by Ryan Drapeau on 5/19/14.
//  Copyright (c) 2014 University of Washington. All rights reserved.
//

#import "HandViewController.h"

@interface HandViewController ()

@end

@implementation HandViewController

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

- (IBAction)right:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"right" forKey:@"hand"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismiss];
}

- (IBAction)left:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"left" forKey:@"hand"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismiss {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
