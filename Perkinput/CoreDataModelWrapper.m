//
//  PersistentStoreCoordinatorWrapper.m
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 3/23/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "CoreDataModelWrapper.h"

@interface CoreDataModelWrapper ()

@end

@implementation CoreDataModelWrapper

+ (id)getPersistentStoreCoordinator
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    if (!model) {
      model = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    persistenceStoreCoordinatorInstance = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    // Set the proper path for storing the data on disk
    NSURL *whereToStore = [NSURL fileURLWithPath:[self pathInDocumentDirectory:@"data.dat"]];
    NSError *error = nil;
    if (![persistenceStoreCoordinatorInstance addPersistentStoreWithType:NSSQLiteStoreType
                                configuration:nil
                                          URL:whereToStore
                                      options:nil
                                        error:&error]) {
      [NSException raise:@"Open failed"
                  format:@"Reason: %@", [error localizedDescription]];
    }
  });
  return persistenceStoreCoordinatorInstance;
}

+ (id)getManagedObjectModel
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    if (!model) {
      model = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
  });
  return model;
}

+ (NSString *)pathInDocumentDirectory:(NSString *)fileName
{
  // Get list of document directories in sandbox
  NSArray *documentDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  // Get one and only document directory from that list
  NSString *documentDirectory = [documentDirs objectAtIndex:0];
  // Append passed in file name to that directory, return it
  return [documentDirectory stringByAppendingPathComponent:fileName];
}

+ (void)clearAllData
{
  NSArray *persistentStores = [persistenceStoreCoordinatorInstance persistentStores];
  // TODO: fix NULLPointerException
  for (NSPersistentStore *persistentStore in persistentStores) {
    NSLog(@"%@", persistentStore);
    NSError *error = nil;
    if (![persistenceStoreCoordinatorInstance removePersistentStore:persistentStore error:&error]) {
      [NSException raise:@"Coordinator error removing" format:@"%@", [error localizedDescription]];
    }
    if (![[NSFileManager defaultManager] removeItemAtPath:persistentStore.URL.path error:&error]) {
      [NSException raise:@"FileManager error removing" format:@"%@", [error localizedDescription]];
    }
    NSURL *whereToStore = [NSURL fileURLWithPath:[self pathInDocumentDirectory:@"data.dat"]];
    if (![persistenceStoreCoordinatorInstance addPersistentStoreWithType:NSSQLiteStoreType
                                                           configuration:nil
                                                                     URL:whereToStore
                                                                 options:nil
                                                                   error:&error]) {
      [NSException raise:@"Open failed"
                  format:@"Reason: %@", [error localizedDescription]];
    }
  }
}

@end
