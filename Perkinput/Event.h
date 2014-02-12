//
//  Event.h
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 3/22/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSNumber * playerId;
@property (nonatomic, retain) NSNumber * eventId;
@property (nonatomic, retain) NSNumber * gameId;
@property (nonatomic, retain) NSNumber * taskId;
@property (nonatomic, retain) NSString * eventType;
@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) NSString * params;

@end
