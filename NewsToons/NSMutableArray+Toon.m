//
//  NSMutableArray+Toon.h
//  
//  Created by Dani Postigo on 6/8/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "NSMutableArray+Toon.h"

@implementation NSMutableArray (Toon)


- (void) addToon: (Toon * ) toon {
    if (![self containsToon: toon] ) {
        [self addObject: toon];
    }

    else {
        NSLog(@"Did not add toon");
    }
}

- (BOOL) containsToon: (Toon * ) toon {

    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"title == %@", toon.title];
    NSArray *filteredToons = [self filteredArrayUsingPredicate: predicate];



    return ([filteredToons count] > 0 ? YES : NO);

}



- (Toon *) toonFromTitle: (NSString * ) aTitle {

    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"title == %@", aTitle];
    NSArray *filteredToons = [self filteredArrayUsingPredicate: predicate];

    if ( [filteredToons count] > 1) {
        NSLog(@"Found %u duplicate toons.", [filteredToons count]);
    }

    if ( [filteredToons count] == 0) return nil;
    return [filteredToons objectAtIndex: 0];

}


@end