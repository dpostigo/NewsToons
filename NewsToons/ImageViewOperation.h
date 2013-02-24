//
//  ImageViewOperation.h
//  
//  Created by Dani Postigo on 4/16/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import <Foundation/Foundation.h>


@interface ImageViewOperation : NSOperation {

    UIImageView *imageView;
    NSURL *imageURL;

}

@property ( nonatomic, retain ) UIImageView * imageView;
@property ( nonatomic, retain ) NSURL * imageURL;

- (id) initWithImageURL: (NSURL *) url imageView: (UIImageView *) view;


@end