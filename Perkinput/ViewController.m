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

// Loads the SMS texting view and injects the text within the text field into the body of the
// text message. This view will only load on devices that have the Messages applicication. The
// user is returned to the Default view when he / she hits the cancel button inside the messages view.
- (IBAction)sendSMS:(id)sender {
    NSLog(@"Device not supported");
    MFMessageComposeViewController *textComposer = [[MFMessageComposeViewController alloc] init];
    [textComposer setMessageComposeDelegate:self];
    
    if ([MFMessageComposeViewController canSendText]) {
        [textComposer setBody:self.textField.text]; // Set message body
        [self presentViewController:textComposer animated:YES completion:NULL];
    }
}

// Loads the email view and injects the text within the text field into the body of the email.
// This view will only load on devices that have the Email applicication (which should be every device). The
// user is returned to the Default view when he / she hits the cancel button inside the email view.
- (IBAction)sendEmail:(id)sender {
    NSLog(@"Device not supported");
    MFMailComposeViewController *emailComposer = [[MFMailComposeViewController alloc] init];
    [emailComposer setMailComposeDelegate:self];
     
    if ([MFMailComposeViewController canSendMail]) {
        [emailComposer setMessageBody:self.textField.text isHTML:NO]; // Set body of email 
        [self presentViewController:emailComposer animated:YES completion:NULL];
    }
}

- (IBAction)howTo:(id)sender {
    [self switchToTutorialView:self];
}

// Copies the text within the text field into the clipboard of the device. This text can be pasted
// anywhere on the device until something else is copied or the device is shut down. 
- (IBAction)sendToClipboard:(id)sender {
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"Copied to Clipboard");
    [UIPasteboard generalPasteboard].string = self.textField.text;
}

// Erases the text in the current text field.
- (IBAction)clearText:(id)sender {
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"Cleared Text Field");
    self.textField.text = @"";
}

// Removes the keyboard from the view when the user taps the done button inside the text field. The
// keyboard is also removed if the user taps anywhere within the view.
- (IBAction)removeKeyboard:(id)sender {
    [self.textField resignFirstResponder];
}

// Dismisses the Email view and returns to the default view.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Dismisses the SMS Texting view and returns to the default view.
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)fingerSwipe:(id)sender {
    [self switchToInputView:self];
}

// Switches to the input view controller (index 1) and announces the change to the user.
- (IBAction)switchToInputView:(id)sender {
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"Input View");
    self.tabBarController.selectedIndex = 1;
}

// Switches to the input view controller (index 1) and announces the change to the user.
- (IBAction)switchToTutorialView:(id)sender {
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"How To View");
    self.tabBarController.selectedIndex = 2;
}

// When the user changes the device to a landscape orientation the view controller is switched the input view.
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (UIDeviceOrientationIsLandscape(self.interfaceOrientation)) {
        [self switchToInputView:self];
    }
}

// Announce to the user which view they are in
- (void)viewWillAppear:(BOOL)animated {
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"Default View");
}

- (void)viewDidLoad {
    self.view.multipleTouchEnabled = YES;
    self.view.userInteractionEnabled = YES;
    [self setNeedsStatusBarAppearanceUpdate];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidUnload {
    [self setTextField:nil];
    [super viewDidUnload];
}

@end
