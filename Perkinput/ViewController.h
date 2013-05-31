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

@interface ViewController : UIViewController <MFMessageComposeViewControllerDelegate> {
    NSString *textInput;
}

- (IBAction)sendSMS:(id)sender; // Sends a Text Message
- (IBAction)sendEmail:(id)sender; // Sends an Email Message
- (IBAction)removeKeyboard:(id)sender; // Dismisses the Keyboard from the current view
- (IBAction)sendToClipboard:(id)sender; // Copies the text to the clipboard
- (IBAction)switchToInputView:(id)sender; // Switches to the input view

@end
