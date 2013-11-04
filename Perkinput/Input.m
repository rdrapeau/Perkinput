//
//  Input.m
//  Perkinput
//
//  Created by Ryan Drapeau on 6/2/13.
//  Copyright (c) 2013 University of Washington. All rights reserved.
//

#import "Input.h"

@implementation Input {
    NSMutableDictionary *lookup;
}



+(void)initialize {

}

// Returns the corresponding character for the layout code.
- (NSString*)getCharacter:(NSString *)layout {
    if (lookup.count == 0) {
        [self readInput];
    }
    return [lookup valueForKey:layout];
}

- (void)readInput {
    lookup = [[NSMutableDictionary alloc] init];
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"brailleCodes" ofType:@"txt"];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
    NSArray *listArray = [fileContents componentsSeparatedByString:@"\n"];
    for (int i = 0; i < listArray.count; i++) {
        NSString *line = [listArray objectAtIndex:i];
        NSString *character = [NSString stringWithFormat:@"%c", [line characterAtIndex:0]];
        NSString *code = [line substringFromIndex:2];
        [lookup setObject:character forKey:code];
    }
}

@end
