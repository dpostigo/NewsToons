//
// Created by dpostigo on 8/30/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicObject.h"

@interface BasicLibrary : BasicObject {
    NSMutableArray *delegates;
}


@property(nonatomic, retain) NSMutableArray *delegates;


- (void) subscribeDelegate: (id) aDelegate;

- (void) unsubscribeDelegate: (id) aDelegate;

- (void) notifyDelegates: (SEL) aSelector object: (id) obj;

@end