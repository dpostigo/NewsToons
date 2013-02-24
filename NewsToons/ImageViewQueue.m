//
//  ImageViewQueue.h
//  
//  Created by Dani Postigo on 4/16/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "ImageViewQueue.h"


@implementation ImageViewQueue {

}

+ (ImageViewQueue *) mainQueue {
    static ImageViewQueue * _instance = nil;

    @synchronized (self) {
        if ( _instance == nil ) {
            _instance = [[self alloc] init];
            _instance.maxConcurrentOperationCount = 1;
        }
    }

    return _instance;
}


@end