//
//  BasicOperation.h
//  
//  Created by Dani Postigo on 6/8/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "BasicOperation.h"


@implementation BasicOperation {

}

@synthesize _model;


- (void) dealloc {
    _model = nil;
    [super dealloc];
}

- (id) init {
    self = [super init];
    if (self) {
        _model = [Model sharedModel];

    }

    return self;
}

@end