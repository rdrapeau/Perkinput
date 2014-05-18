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

static NSString *const textMessageAnnouncement = @"Launching text message view";
static NSString *const emailMessageAnnouncement = @"Launching email view";
static NSString *const copiedTextToClipboardAnnouncement = @"Copied text to clipboard";
static NSString *const clearTextFieldAnnouncement = @"Cleared text field";
static NSString *const mainScreenAnnouncement = @"Entering main screen";

@implementation ViewController

/**
 * Loads the text message view with the message pre-populated with whatever was in the text field.
 *
 * Nothing happens if the device does not support text messaging.
 */
- (IBAction)sendSMS:(id)sender {
    if ([MFMessageComposeViewController canSendText]) {
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, textMessageAnnouncement);
        MFMessageComposeViewController *textComposer = [[MFMessageComposeViewController alloc] init];
        [textComposer setMessageComposeDelegate:self];
        [textComposer setBody:self.textField.text]; // Set message body
        [self presentViewController:textComposer animated:YES completion:NULL];
    }
}

/**
 * Dismisses the SMS Texting view and returns to the default view.
 */
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

/**
 * Loads the email message view with the body of the email pre-populated with whatever was in the
 * text field.
 *
 * Nothing happens if the device does not support email messaging.
 */
- (IBAction)sendEmail:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, emailMessageAnnouncement);
        MFMailComposeViewController *emailComposer = [[MFMailComposeViewController alloc] init];
        [emailComposer setMailComposeDelegate:self];
        [emailComposer setMessageBody:self.textField.text isHTML:NO]; // Set body of email 
        [self presentViewController:emailComposer animated:YES completion:NULL];
    }
}

/** 
 * Dismisses the Email view and returns to the default view.
 */
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

/**
 * Copies the text in the text field into the clipboard.
 */
- (IBAction)sendToClipboard:(id)sender {
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, copiedTextToClipboardAnnouncement);
    [UIPasteboard generalPasteboard].string = self.textField.text;
}

/**
 * Clears and erases the text in the text field.
 */
- (IBAction)clearText:(id)sender {
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, clearTextFieldAnnouncement);
    self.textField.text = @"";
}

/**
 * Remove the keyboard from the current view.
 */
- (IBAction)removeKeyboard:(id)sender {
    [self.textField resignFirstResponder];
}

/**
 * Switches to the input view controller (index 1)
 */
- (IBAction)switchToInputView:(id)sender {
    self.tabBarController.selectedIndex = 1;
}

/**
 * Switches to the tutorial view controller (index 2)
 */
- (IBAction)switchToTutorialView:(id)sender {
    self.tabBarController.selectedIndex = 2;
}

/**
 * Switches to the agreement view controller (index 3)
 */
- (IBAction)switchToAgreementView:(id)sender {
    self.tabBarController.selectedIndex = 3;
}

/**
 * When the user changes the device to a landscape orientation the view controller is switched the input view.
 */
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (UIDeviceOrientationIsLandscape(self.interfaceOrientation)) {
        [self switchToInputView:self];
    } else {
        [self.view setNeedsLayout];
        [self.view setNeedsUpdateConstraints];
    }
}

/**
 * Announce to the user which view they are in
 */
- (void)viewDidAppear:(BOOL)animated {
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, mainScreenAnnouncement);
}

/**
 * Set up the screen for touch events and if it is the first time launching the app, then bring up
 * the agreement view.
 */
- (void)viewDidLoad {
    self.view.multipleTouchEnabled = YES;
    self.view.userInteractionEnabled = YES;
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self setNeedsStatusBarAppearanceUpdate];
    
    // Show the terms and conditions page
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"termsAndConditions"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"termsAndConditions"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSelector:@selector(switchToAgreementView:) withObject:nil afterDelay:0.01];
    }
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidUnload {
    [self setTextField:nil];
    [super viewDidUnload];
}

@end
