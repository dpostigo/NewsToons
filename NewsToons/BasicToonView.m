//
//  BasicToonView.m
//  NewsToons
//
//  Created by Daniela Postigo on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BasicToonView.h"

@implementation BasicToonView

@synthesize toonObject;

- (void) dealloc {
    [toonObject release];
    [super dealloc];
}

@end
