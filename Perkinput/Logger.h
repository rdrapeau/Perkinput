//
//  Logger.h
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 3/3/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

#import "Event.h"
#import "EventType.h"
#import "CoreDataModelWrapper.h"

@interface Logger : NSObject
{
  @private
  NSManagedObjectContext *manageContext;
  NSOperationQueue *operationQueue;
}

+ (id)getInstance;

// log an event to CoreData
- (void)logWithEvent:(Type)event andParams:(NSString *)params andUID:(NSUInteger)uid andGameId:(NSUInteger)gid andTaskId:(NSUInteger)tid andTime:(long)time andIsVoiceOverOn:(BOOL)isVoiceOverOn;

// sends all the logs to the server
- (void)sendLogsToServer;

@end
