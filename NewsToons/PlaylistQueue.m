//
//  PlaylistQueue.h
//  
//  Created by Dani Postigo on 4/16/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "PlaylistQueue.h"


@implementation PlaylistQueue {

}


+ (PlaylistQueue *) mainQueue {
    static PlaylistQueue * _instance = nil;

    @synchronized (self) {
        if ( _instance == nil ) {
            _instance = [[self alloc] init];
            //_instance.maxConcurrentOperationCount = 1;
        }
    }

    return _instance;
}

@end