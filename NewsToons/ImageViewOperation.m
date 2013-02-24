//
//  ImageViewOperation.h
//  
//  Created by Dani Postigo on 4/16/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "ImageViewOperation.h"
#import "UIImage+Addons.h"
#import "Model.h"


@implementation ImageViewOperation {

}

@synthesize imageView;
@synthesize imageURL;




- (id) initWithImageURL: (NSURL *) url imageView: (UIImageView *) view {
    self = [super init];
    if ( self ) {
        imageURL = [url retain];
        imageView = [view retain];
        imageView.alpha = 0;
    }

    return self;

}


- (void) dealloc {
    [super dealloc];
}

- (void) main {


    UIImage * image = [[Model sharedModel] loadOptimizedImageFromURL: imageURL];
    [imageURL release];
    imageView.image = image;


    /*
    [UIView animateWithDuration: 1.0
                          delay: 0.0
                        options: UIViewAnimationCurveEaseOut
                     animations: ^(void){
                         imageView.alpha = 1.0;
    }
                     completion: ^(BOOL finished) {
                         //[imageView release];
                         NSLog(@"HELLO?");

    }];

         */

}


@end