//
//  NSMutableArray+Toon.h
//  
//  Created by Dani Postigo on 6/8/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import <Foundation/Foundation.h>
#import "Toon.h"

@interface NSMutableArray (Toon)

- (void) addToon: (Toon *) toon;
- (BOOL) containsToon: (Toon *) toon;
- (Toon *) toonFromTitle: (NSString *) aTitle;


@end