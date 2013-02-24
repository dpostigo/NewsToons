//
//  CLLocation+JSON.m
//  Demo
//
//  Created by Wei Kong on 11/22/11.
//  Copyright (c) 2011 Cocoafish Inc. All rights reserved.
//

#import "CLLocation+JSON.h"
#import <YAJL/YAJL.h>

@implementation CLLocation (JSON)
- (id)JSON
{
    double latitude = self.coordinate.latitude;
    double longitude = self.coordinate.longitude;
    return [NSArray arrayWithObjects:[NSNumber numberWithDouble:longitude], [NSNumber numberWithDouble:latitude], nil];
}
@end
