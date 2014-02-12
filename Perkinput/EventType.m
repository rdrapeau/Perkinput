//
//  EventType.m
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 3/23/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "EventType.h"

@implementation EventType

+ (NSString *)description:(Type)type
{
  switch (type) {
    case GAME_START: {
      return @"GAME_START";
    }
    case GAME_END: {
      return @"GAME_END";
    }
    case LEVEL_START: {
      return @"LEVEL_START";
    }
    case LEVEL_END: {
      return @"LEVEL_END";
    }
    case GESTURE_TAP: {
      return @"GESTURE_TAP";
    }
    case GESTURE_SWIPE: {
      return @"GESTURE_SWIPE";
    }
    case NUMBER_PRESENTED: {
      return @"NUMBER_PRESENTED";
    }
    case NUMBER_ENTERED: {
      return @"NUMBER_ENTERED";
    }
    default: {
      [NSException raise:@"Unsupported event type" format:nil];
    }
  }
}

@end
