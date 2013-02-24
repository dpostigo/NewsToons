//
//  UIView+Toons.h
//  
//  Created by Dani Postigo on 3/27/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "UIView+Toons.h"
#import "NSString+Addons.h"
#import "UIImage+Addons.h"


@implementation UIView (Toons)


- (void) formatTextLabel: (UILabel *) textLabel string: (NSString *) str {

    textLabel.text = [str stripURLString];
    textLabel.font = [textLabel.font fontWithSize: 12.0];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.clipsToBounds = NO;
    textLabel.backgroundColor = [UIColor clearColor];
}

- (UIImageView *) quickBackgroundImage {

    UIImage * image = [[UIImage newImageFromResource: @"background.png"] autorelease];
    UIImageView *background = [[[UIImageView alloc] initWithImage: image] autorelease];
    background.contentMode = UIViewContentModeScaleAspectFit;
    return background;
}


- (UIImageView *) logoBackground {

    UIImage * image = [[UIImage newImageFromResource: @"top-image.png"] autorelease];
    UIImageView *background = [[[UIImageView alloc] initWithImage: image] autorelease];
    background.contentMode = UIViewContentModeScaleAspectFit;
    return background;
}


@end