//
//  EventType.h
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 3/23/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum Type {
  GAME_START = 0,
  GAME_END = 1,
  LEVEL_START = 2,
  LEVEL_END = 3,
  GESTURE_TAP = 4,
  GESTURE_SWIPE = 5,
  NUMBER_PRESENTED = 6,
  NUMBER_ENTERED = 7
} Type;

@interface EventType : NSObject

+ (NSString *)description:(Type)type;

@end
