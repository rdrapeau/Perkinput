//
//  ViewController.h
//  Perkinput
//
//  Created by Ryan Drapeau on 4/9/13.
//  Copyright (c) 2013 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <MFMessageComposeViewControllerDelegate>

- (IBAction)sendSMS:(id)sender; // Sends a Text Message

- (IBAction)sendEmail:(id)sender; // Sends an Email Message

- (IBAction)sendToClipboard:(id)sender; // Copies the text to the clipboard

@property (strong, nonatomic) IBOutlet UITextField *textField; // Reference to the text field

@end
