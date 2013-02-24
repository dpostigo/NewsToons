//
//  UIImageView+Addons.h
//  
//  Created by Dani Postigo on 4/16/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "UIImageView+Addons.h"
#import "ImageViewOperation.h"
#import "ImageViewQueue.h"
#import "Model.h"


@implementation UIImageView (Addons)

- (void) loadFromURL: (NSURL *) imageURL {


    self.alpha = 0;
    self.image = [[Model sharedModel] loadOptimizedImageFromURL: imageURL];

    [UIView animateWithDuration: 1.0 animations: ^ {
        self.alpha = 1;
    }];
}




@end