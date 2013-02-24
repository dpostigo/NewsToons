//
//  VideoFeedOperation.h
//  
//  Created by Dani Postigo on 4/9/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import <Foundation/Foundation.h>
#import "FeedOperation.h"
#import "Toon.h"


@interface VideoFeedOperation : FeedOperation <FeedOperationProtocol> {
    Toon * toon;
    NSDateFormatter *dateFormatter;
}

@property ( nonatomic, retain ) Toon * toon;
@property(nonatomic, retain) NSDateFormatter *dateFormatter;

@end