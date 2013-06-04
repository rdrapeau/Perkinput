//
//  ViewController.m
//  Perkinput
//
//  Created by Ryan Drapeau on 4/9/13.
//  Copyright (c) 2013 University of Washington. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

// Sends an SMS message
- (IBAction)sendSMS:(id)sender {
    MFMessageComposeViewController *textComposer = [[MFMessageComposeViewController alloc] init];
    [textComposer setMessageComposeDelegate:self];
    
    if ([MFMessageComposeViewController canSendText]) {
        [textComposer setBody:self.textField.text]; // Set message here
        [self presentViewController:textComposer animated:YES completion:NULL];
    }
}

// Sends an Email message
- (IBAction)sendEmail:(id)sender {
    MFMailComposeViewController *emailComposer = [[MFMailComposeViewController alloc] init];
    [emailComposer setMailComposeDelegate:self];
     
    if ([MFMailComposeViewController canSendMail]) {
        [emailComposer setMessageBody:self.textField.text isHTML:NO];
        [self presentViewController:emailComposer animated:YES completion:NULL];
    }
}

// Copies the text in the teftField into the clipboard for later use
- (IBAction)sendToClipboard:(id)sender {
    if (UIAccessibilityIsVoiceOverRunning()) {
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"Text Copied");
    }
    [UIPasteboard generalPasteboard].string = self.textField.text;
}

// Dismisses the keyboard
- (IBAction)removeKeyboard:(UITextField *)sender {
    [sender resignFirstResponder];
}

// Dismisses the Email view controller and returns to the default view controller
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Dismisses the SMS Texting view controller and returns to the default view controller
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Switches the app to the second view controller for the input view
- (IBAction)switchToInputView:(id)sender {
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"Input View");
    self.tabBarController.selectedIndex = 1;
}

// If the view is in landscape: switch to input mode
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        [self switchToInputView:self];
    }
}

// Announce to the user which view they are in
- (void)viewWillAppear:(BOOL)animated {
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"Default View");
}

- (void)viewDidUnload {
    [self setTextField:nil];
    [super viewDidUnload];
}
@end
