//
//  NotificationQueue.h
//  Perkinput
//
//  Created by Ryan Drapeau on 5/22/14.
//  Copyright (c) 2014 University of Washington. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationQueue : NSObject

+ (NotificationQueue*)getInstance;
- (void)addNotification:(NSString*)announcement;
- (void)clearNotifications;
- (void)postNextNotification;

@end
