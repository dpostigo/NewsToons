//
//  UIImage+Addons.h
//  NewsToons
//
//  Created by Daniela Postigo on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Addons)



- (UIImage *) scale:(UIImage *)image toSize:(CGSize)size;
- (UIImage *) crop: (UIImage *)image toSize: (CGSize) size centered: (BOOL) center;
- (UIImage *) crop: (UIImage *)image toRect: (CGRect) rect;

+ (UIImage *) optimize: (UIImage *) image;


+ (UIImage *) newImageFromResource:(NSString *)filename;
+ (UIImage *) newImageFromURL: (NSURL *) imageURL;

@end
