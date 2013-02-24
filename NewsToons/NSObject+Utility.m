//
//  NSObject+Utility.h
//  
//  Created by Dani Postigo on 4/16/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "NSObject+Utility.h"


@implementation NSObject (Utility)


- (void) addSelector: (SEL) aSelector name: (NSString *) aName  {
    [self addSelector: aSelector name: aName withObject: nil];
}

- (void) addSelector: (SEL) aSelector name: (NSString *) aName withObject: (id)anObject {
    [[NSNotificationCenter defaultCenter] addObserver: self selector: aSelector name: aName object: anObject];
}

- (void) removeSelector: (NSString *) aName {
    [[NSNotificationCenter defaultCenter] removeObserver: self name: aName object: nil];
}


@end