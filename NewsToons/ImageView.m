//
//  ImageView.h
//  
//  Created by Dani Postigo on 4/16/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "ImageView.h"
#import "UIImage+Addons.h"
#import "ImageViewQueue.h"
#import "ImageViewOperation.h"


@implementation ImageView {
    NSMutableData * receivedData;
    NSURLConnection * connection;
}

- (void) dealloc {
    [receivedData release];
    [connection release];
    [super dealloc];
}

- (void) loadFromURL: (NSURL *) imageURL {

    ImageViewOperation *operation = [[[ImageViewOperation alloc] initWithImageURL: imageURL imageView: self] autorelease] ;
    [[ImageViewQueue mainQueue] addOperation: operation];

}



@end