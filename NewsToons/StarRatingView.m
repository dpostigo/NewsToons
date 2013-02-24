//
//  StarRatingView.h
//  
//  Created by Dani Postigo on 3/26/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "StarRatingView.h"
#import "UIImage+Addons.h"
#import "UIView+Addons.h"

#define maxStars 5
#define fullStarString @"full-star.png"
#define halfStarString @"half-star.png"
#define emptyStarString @"empty-star.png"

@implementation StarRatingView {

}

@synthesize rating;



- (void) setRating: (CGFloat) aRating {
    rating = aRating;

    [self removeAllSubviews];




    UIImage *image;
    UIImageView * starView;
	int i = 0;
    int fullStars = 0;
    CGFloat padding = 0;
    for (i = 0; i < aRating; i ++ ){
		image = [[UIImage newImageFromResource:fullStarString] autorelease];
        starView = [[[UIImageView alloc] initWithImage: image] autorelease];
		
		[self addSubview:starView];
        starView.left = i * (starView.width + padding);
    }


    fullStars = i;
    for (i = fullStars; i < maxStars; i++){
		image = [[UIImage newImageFromResource: emptyStarString] autorelease];
        starView = [[[UIImageView alloc] initWithImage: image] autorelease];
		[self addSubview:starView];
        starView.left = i * (starView.width + padding);
        starView.alpha = 0.6;
    }


    self.width = starView.left + starView.width;
    self.height = starView.bounds.size.height;

}



@end