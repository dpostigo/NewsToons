//
//  NSObject+Utility.h
//  
//  Created by Dani Postigo on 4/16/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import <Foundation/Foundation.h>

@interface NSObject (Utility)

- (void) removeSelector: (NSString *) aName;

- (void) addSelector: (SEL) aSelector name: (NSString *) aName;
- (void) addSelector: (SEL) aSelector name: (NSString *) aName withObject: (id) anObject;


@end