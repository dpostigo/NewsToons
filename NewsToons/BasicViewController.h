//
//  BasicViewController.h
//  NewsToons
//
//  Created by Daniela Postigo on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Model;

@interface BasicViewController : UIViewController {


    Model * _model;
    NSOperationQueue *_queue;


}

@property(nonatomic, retain) NSOperationQueue *queue;
- (Model *) model;
- (void) initializeBasics;
- (void) resetViewController;

/*
- (void) addSelector: (SEL) aSelector name: (NSString *) aName withObject: (id) anObject;
- (void) removeSelectorForName: (NSString *) aName withObject: (id) anObject;
- (void) removeSelector: (NSString *) aName;
*/

@end
