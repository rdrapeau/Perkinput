//
//  NotificationQueue.m
//  Perkinput
//
//  Created by Ryan Drapeau on 5/22/14.
//  Copyright (c) 2014 University of Washington. All rights reserved.
//

#import "NotificationQueue.h"

@implementation NotificationQueue

static NotificationQueue *singleton = nil;
static NSMutableArray *queue = nil;

- (id)init {
    self = [super init];
    if (self) {
        queue = [[NSMutableArray alloc] init];
    }
    return self;
}

// Returns the single instance of the NotificationQueue
+ (NotificationQueue*)getInstance {
    singleton = [[NotificationQueue alloc] init];
    return singleton;
}

- (void)addNotification:(NSString *)announcement {
    [queue addObject:announcement];
    NSLog(@"Adding Object");
}

- (void)clearNotifications {
    [queue removeAllObjects];
}

- (void)postNextNotification {
    if ([queue count] > 0) {
        NSString *announcement = [queue objectAtIndex:[queue count] - 1];
        NSLog(announcement);
        [queue removeLastObject];
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, announcement);
    }
}



@end
