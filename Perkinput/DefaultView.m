//
//  DefaultView.m
//  Perkinput
//
//  Created by Ryan Drapeau on 5/30/13.
//  Copyright (c) 2013 University of Washington. All rights reserved.
//

#import "DefaultView.h"

@implementation DefaultView

- (id)initWithFrame:(CGRect)frame {
    return [super initWithFrame:frame];
}

/** 
 * This custom view behaves like a button so the user can touch and interact with the screen even 
 * if VoiceOver is turned on.
 */
- (UIAccessibilityTraits)accessibilityTraits {
    return UIAccessibilityTraitAllowsDirectInteraction;
}

@end
