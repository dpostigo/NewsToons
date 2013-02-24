//
//  LoaderImageView.m
//  NewsToons
//
//  Created by Daniela Postigo on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LoaderImageView.h"

@implementation LoaderImageView

@synthesize placeholder;

- (void) dealloc {
    [placeholder release];
    [super dealloc];
}

- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame: frame];
    if ( self ) {
        placeholder = [[UIView alloc] initWithFrame: frame];
        placeholder.backgroundColor = [UIColor blackColor];
        placeholder.layer.cornerRadius = frame.size.width / 8;
        [self addSubview: placeholder];
    }

    return self;
}

- (void) setImage: (UIImage *) anImage {

    imageView = [[UIImageView alloc] initWithImage: anImage];
    imageView.alpha = 0;
    [self addSubview: imageView];

    [UIView beginAnimations: @"" context: nil];
    imageView.alpha = 1;
    [UIView commitAnimations];

}


@end
