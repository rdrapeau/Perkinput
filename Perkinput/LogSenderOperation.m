//
//  LogSenderOperation.m
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 4/15/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "LogSenderOperation.h"

@implementation LogSenderOperation

static NSString *kUrl = @"http://staff.washington.edu/drapeau/logger.php";

- (id)init
{
  if ((self = [super init]) != nil) {
    dataSender = [[DataSender alloc] init];
  }
  return self;
}

// main method for NSOperation
- (void)main
{
  NSLog(@"LogSenderOperation: sending logs over");
  // Fetch all the events stored in the CoreData
  NSPersistentStoreCoordinator *coordinator = [CoreDataModelWrapper getPersistentStoreCoordinator];
  NSManagedObjectContext *objContext = [[NSManagedObjectContext alloc] init];
  [objContext setPersistentStoreCoordinator:coordinator];
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entityDescription = [[[CoreDataModelWrapper getManagedObjectModel] entitiesByName] objectForKey:@"Event"];
  [fetchRequest setEntity:entityDescription];
  NSError *e = nil;
  NSArray *result = [objContext executeFetchRequest:fetchRequest error:&e];
  if (!result) {
    [NSException raise:@"Fetch failed" format:@"Reason: %@", [e localizedDescription]];
  }

  // Send all the events to the server
  for (Event *event in result) {
    NSArray *keys = [[[event entity] attributesByName] allKeys];
    NSDictionary *logToSend = [event dictionaryWithValuesForKeys:keys];
    if ([dataSender sendData:logToSend toURL:[NSURL URLWithString:kUrl] andReceived:nil]) {
      // after we send the event to the server successfully, delete it from persistent storage.
      [objContext deleteObject:event];
      NSError *error;
      if (![objContext save:&error]) {
        // save failed
        [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
      }
    }
  }

}

@end
