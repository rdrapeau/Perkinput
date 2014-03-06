//
//  Validator.h
//  Perkinput
//
//  Created by Ryan Drapeau on 3/5/14.
//  Copyright (c) 2014 University of Washington. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Validator : NSObject

+ (Validator*)getInstance;
- (BOOL)isWord:(NSString*)word;

@end
