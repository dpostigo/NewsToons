//
//  NSDate+JSON.m
//  Demo
//
//  Created by Kalila on 11/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDate+JSON.h"
#import <YAJL/YAJL.h>

@implementation NSDate (JSON)
- (id)JSON
{
    return [self description];
}

@end
