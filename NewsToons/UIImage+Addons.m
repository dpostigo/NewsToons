//
//  UIImage+Addons.m
//  NewsToons
//
//  Created by Daniela Postigo on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Addons.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (Addons)

- (UIImage *) scale:(UIImage *)image toSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


- (UIImage *) crop: (UIImage *)image toSize: (CGSize) size {
	CGRect rect = CGRectMake(0, 0, size.width, size.height);
	return [self crop:image toRect:rect];
}


- (UIImage *) crop: (UIImage *)image toSize: (CGSize) size centered: (BOOL) center {
	CGRect rect = CGRectMake( (image.size.width - size.width)/2, 
							 (image.size.height - size.height)/2, 
							 size.width, 
							 size.height);
	return [self crop:image toRect:rect];
	
}

- (UIImage *) crop: (UIImage *)image toRect: (CGRect) rect {
	CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
	UIImage *newImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	return newImage;
	
}


+ (UIImage *) optimize: (UIImage *) image {

    UIImage * newImage;

    CGFloat toWidth = image.size.width * 2.85;
    CGFloat prop = toWidth / image.size.width;
    CGSize newSize = CGSizeMake(toWidth, image.size.height * prop);

    UIGraphicsBeginImageContext(newSize);
    [image drawInRect: CGRectMake(0, 0, newSize.width, newSize.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;


}

+ (UIImage *) newImageFromURL: (NSURL *) imageURL {
    NSData * data = [NSData dataWithContentsOfURL: imageURL];
    UIImage * image = [[UIImage alloc] initWithData: data];
    return image;
}

+ (UIImage *) newImageFromResource:(NSString *)filename {
    NSString *imageFile = [[NSString alloc] initWithFormat:@"%@/%@",
                                                           [[NSBundle mainBundle] resourcePath], filename];
    UIImage *image = nil;
    image = [[UIImage alloc] initWithContentsOfFile:imageFile];
    [imageFile release];
    return image;
}

@end
