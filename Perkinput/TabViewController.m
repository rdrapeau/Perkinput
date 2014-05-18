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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (BOOL)shouldAutorotate {
    if (self.selectedViewController.class == [TutorialViewController class]
            || self.selectedViewController.class == [AgreementViewController class]) {
        return NO;
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
