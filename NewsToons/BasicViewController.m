//
//  BasicViewController.m
//  NewsToons
//
//  Created by Daniela Postigo on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BasicViewController.h"
#import "Model.h"
#import "NSObject+Utility.h"


@implementation BasicViewController {
}


@synthesize queue = _queue;


- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [_model unsubscribeDelegate: self];
    [_queue release];
    [super dealloc];
}


- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        [self initializeBasics];
    }

    return self;
}


- (id) initWithCoder: (NSCoder *) aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {
        [self initializeBasics];
    }

    return self;
}


- (void) awakeFromNib {
    [super awakeFromNib];
    [self initializeBasics];
}


- (void) initializeBasics {
    _model = [Model sharedModel];
    _queue = [NSOperationQueue new];
    _queue.name = NSStringFromClass([self class]);
    [_model subscribeDelegate: self];
}


- (void) resetViewController {
}


- (Model *) model {
    return [Model sharedModel];
}


- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];

    NSLog(@"%s", __PRETTY_FUNCTION__);

    NSLog(@"NOT ALLOWING LANDSCAPE");
    _model.shouldSupportLandscape = NO;
}


@end
