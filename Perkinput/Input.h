//
//  Input.h
//  Perkinput
//
//  Created by Ryan Drapeau on 6/2/13.
//  Copyright (c) 2013 University of Washington. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Input : NSObject {
    BOOL isCapital;
    BOOL isNumber;
    NSMutableDictionary *lookup;
    NSMutableDictionary *capitals;
    NSMutableDictionary *modes;
    NSMutableDictionary *numbers;
}

-(NSString*)getCharacter:(NSString*)layout;

@end
