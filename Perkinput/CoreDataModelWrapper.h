//
//  PersistentStoreCoordinatorWrapper.h
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 3/23/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//
#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

static NSManagedObjectModel *model;
static NSPersistentStoreCoordinator *persistenceStoreCoordinatorInstance = nil;

@interface CoreDataModelWrapper : NSObject

// returns the persistentStoreCoordinator with the corresponding model(s)
+ (id)getPersistentStoreCoordinator;

// returns the managed object model
+ (id)getManagedObjectModel;

// clears all the data from the persistent store coordinator
+ (void)clearAllData;

@end