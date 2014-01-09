//
//  Input.m
//  Perkinput
//
//  Created by Ryan Drapeau on 6/2/13.
//  Copyright (c) 2013 University of Washington. All rights reserved.
//

#import "Input.h"

@implementation Input {
    
}

// Returns the corresponding character for the layout code.
- (NSString*)getCharacter:(NSString *)layout {
    if (lookup.count == 0 || modes.count == 0 || numbers.count == 0 || capitals.count == 0) {
        lookup = [[NSMutableDictionary alloc] init];
        modes = [[NSMutableDictionary alloc] init];
        numbers = [[NSMutableDictionary alloc] init];
        capitals = [[NSMutableDictionary alloc] init];
        [self readInput:@"brailleCodes" withDictionary:lookup];
        [self readInput:@"modes" withDictionary:modes];
        [self readInput:@"numbers" withDictionary:numbers];
        [self readInput:@"capitals" withDictionary:capitals];
    }
    NSString *result = nil;
    int oneCount = [[layout componentsSeparatedByString:@"1"] count] - 1;
    if ([modes valueForKey:layout] || oneCount == 6) {
        NSString *mode = [modes valueForKey:layout];
        if ([mode isEqualToString:@"CAPITAL"]) { // Capital Mode
            isCapital = !isCapital;
            isNumber = NO;
            return @"CAPITAL";
        } else if ([mode isEqualToString:@"NUMBER"]) {
            isNumber = !isNumber;
            isCapital = NO;
            return @"NUMBER";
        } else if (oneCount == 6 || [mode isEqualToString:@"BACKSPACE"]) {
            isCapital = NO;
            isNumber = NO;
            return @"BACKSPACE";
        }
    } else {
        if (isCapital) {
            if ([capitals valueForKey:layout]) {
                result = [capitals valueForKey:layout];
            }
            isCapital = NO;
        } else if (isNumber) {
            if ([numbers valueForKey:layout]) {
                result = [numbers valueForKey:layout];
            } else {
                isNumber = NO;
            }
        }
        if (result == nil) {
            result = [lookup valueForKey:layout];
        }
    }
    return result;
}

- (void)readInput:(NSString*)path withDictionary:(NSMutableDictionary*)dict {
    NSString *filepath = [[NSBundle mainBundle] pathForResource:path ofType:@"txt"];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
    NSArray *listArray = [fileContents componentsSeparatedByString:@"\n"];
    for (int i = 0; i < listArray.count; i++) {
        NSArray *line = [[listArray objectAtIndex:i] componentsSeparatedByString:@","];
        NSString *character = [line objectAtIndex:0];
        NSString *code = [line objectAtIndex:1];
        [dict setObject:character forKey:code];
    }
}

@end
