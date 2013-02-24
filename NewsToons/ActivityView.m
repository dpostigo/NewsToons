//
//  ${FILENAME}
//  
//  Created by Dani Postigo on 3/21/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "ActivityView.h"


@implementation ActivityView {

}

- (void) stopAnimating {
    [super stopAnimating];

    [UIView beginAnimations: @"activity" context: nil];
    [UIView setAnimationDuration: 1.0];
    [UIView setAnimationDidStopSelector: @selector(removeActivityView)];
	[self removeFromSuperview];
    //self.alpha = 0;
    [UIView commitAnimations];
}

- (void) removeActivityView {
    [self removeFromSuperview];
}


@end