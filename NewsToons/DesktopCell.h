//
//  DesktopIcon.h
//  NewsToons
//
//  Created by Daniela Postigo on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Toon.h"
#import "BasicToonView.h"
#import "BadgeView.h"

@interface DesktopCell : BasicToonView {

    CGRect privateFrame;

    IBOutlet UILabel *toonTitle;
    IBOutlet UILabel *toonDate;

    IBOutlet UIImageView *imageView;
    IBOutlet UIImageView *divider;
    IBOutlet UIImageView *dropShadow;
    IBOutlet UIImageView *smallImageView;
    BadgeView *badge;
}

@property(nonatomic, retain) IBOutlet UIImageView *imageView;
@property(nonatomic, retain) IBOutlet UIImageView *dropShadow;
@property(nonatomic, retain) IBOutlet UIImageView *smallImageView;
@property(nonatomic, retain) IBOutlet UIImageView *divider;
@property(nonatomic, retain) NSString *thumbnailSize;
@property(nonatomic, retain) BadgeView *badge;


//- (BOOL) showsBadge;
//- (void) setShowsBadge: (BOOL) b;

- (void) handleThumbnail;
- (void) smallThumbnail;
- (void) miniThumbnail;
- (void) mediumThumbnail;
- (void) largeThumbnail;
- (CGFloat) width;
- (void) setWidth: (CGFloat) w;

@end
