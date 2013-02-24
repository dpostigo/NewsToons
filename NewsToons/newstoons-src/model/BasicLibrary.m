//
// Created by dpostigo on 8/30/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicLibrary.h"

@implementation BasicLibrary {
}

@synthesize delegates;

- (void) dealloc {

    [delegates release];
    [super dealloc];
}

- (id) init {
    self = [super init];
    if (self) {
        self.delegates = [[[NSMutableArray alloc] init] autorelease];
    }

    return self;
}

- (void) subscribeDelegate: (id) aDelegate {
    if (![delegates containsObject: aDelegate]) [delegates addObject: aDelegate];
}

- (void) unsubscribeDelegate: (id) aDelegate {
    [delegates removeObject: aDelegate];
}

- (void) notifyDelegates: (SEL) aSelector object: (id) obj {

    for (id delegate in delegates) {
        if ([delegate respondsToSelector: aSelector]) {
            [delegate performSelectorOnMainThread: aSelector withObject: obj waitUntilDone: NO];
        }
    }
}

@end