//
//  DataSender.m
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 3/25/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "DataSender.h"
#import "CoreDataModelWrapper.h"

@implementation DataSender

static NSString *kHostName = @"staff.washington.edu/drapeau/logger.php";

- (id)init
{
  if ((self = [super init]) != nil) {
    NSPersistentStoreCoordinator *dataStoreCoordinator = [CoreDataModelWrapper getPersistentStoreCoordinator];
    manageContext = [[NSManagedObjectContext alloc] init];
    [manageContext setPersistentStoreCoordinator:dataStoreCoordinator];
    reachability = [Reachability reachabilityWithHostname:kHostName];
  }
  return self;
}

- (BOOL)sendData:(NSDictionary *)data toURL:(NSURL *)url andReceived:(NSString **)response
{
  ASIFormDataRequest *formDataRequest = [ASIFormDataRequest requestWithURL:url];
  for (NSString *key in [data keyEnumerator]) {
    [formDataRequest setPostValue:[data objectForKey:key] forKey:key];
  }
  [formDataRequest startSynchronous];
  NSError *error = [formDataRequest error];
  if (formDataRequest.responseStatusCode != 200 || error) {
    return NO;
  }
  if (response != nil) {
    *response = formDataRequest.responseString;
  }
  return YES;
}

@end
