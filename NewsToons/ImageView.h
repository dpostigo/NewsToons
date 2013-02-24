//
//  ImageView.h
//  
//  Created by Dani Postigo on 4/16/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import <Foundation/Foundation.h>


@interface ImageView : UIImageView <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {

}

- (void) loadFromURL: (NSURL *) imageURL;


@end