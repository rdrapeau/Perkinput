//
//  Logger.m
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 3/3/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "Logger.h"

#import "LogSenderOperation.h"

@interface Logger()

@end

@implementation Logger

+ (id)getInstance
{
    static Logger *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Logger alloc] init];
        
    });
    return instance;
}

- (id)init
{
    if ((self = [super init]) != nil) {
        NSPersistentStoreCoordinator *dataStoreCoordinator = [CoreDataModelWrapper getPersistentStoreCoordinator];
        manageContext = [[NSManagedObjectContext alloc] init];
        [manageContext setPersistentStoreCoordinator:dataStoreCoordinator];
        operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)logWithEvent:(Type)event andParams:(NSString *)params andUID:(NSUInteger)uid andGameId:(NSUInteger)gid andTaskId:(NSUInteger)tid andTime:(long)time andIsVoiceOverOn:(BOOL)isVoiceOverOn
{
    // write the event to CoreData. Should ensure consistency here, since we are
    // reading from another thread to send the data to the server
    NSEntityDescription *eventEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:manageContext];
    
    // populate the entity with values
    [eventEntity setValue:[NSNumber numberWithInt:event] forKey:@"eventId"];
    [eventEntity setValue:[NSNumber numberWithUnsignedLong:gid] forKey:@"gameId"];
    [eventEntity setValue:params forKey:@"params"];
    [eventEntity setValue:[NSNumber numberWithLong:time] forKey:@"timestamp"];
    [eventEntity setValue:[NSNumber numberWithUnsignedLong:tid] forKey:@"taskId"];
    [eventEntity setValue:[NSNumber numberWithUnsignedLong:uid] forKey:@"playerId"];
    [eventEntity setValue:[EventType description:event] forKey:@"eventType"];
    
    [manageContext save:nil];
}

- (void)sendLogsToServer
{
    LogSenderOperation *logSenderOperation = [[LogSenderOperation alloc] init];
    [operationQueue addOperation:logSenderOperation];
}

@end
