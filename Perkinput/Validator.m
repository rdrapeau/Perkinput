//
//  Validator.m
//  Perkinput
//
//  Created by Ryan Drapeau on 3/5/14.
//  Copyright (c) 2014 University of Washington. All rights reserved.
//

#import "Validator.h"

@implementation Validator

static Validator *singleton = nil;
static NSMutableSet *words = nil;

- (id)init {
    self = [super init];
    if (self) {
        [self readInput:@"words"];
    }
    return self;
}

// Returns the single instance of the validator
+ (Validator*)getInstance {
    if (singleton == nil || words == nil) {
        words = [[NSMutableSet alloc] init];
        singleton = [[Validator alloc] init];
    }
    return singleton;
}

// Read in all the words
- (void)readInput:(NSString*)fileName {
    NSString *filepath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
    NSArray *listArray = [fileContents componentsSeparatedByString:@"\n"];
    for (int i = 0; i < listArray.count; i++) {
        [words addObject:[listArray objectAtIndex:i]];
    }
}

- (BOOL)isWord:(NSString*)word {
    return [words containsObject:word];
}

@end
