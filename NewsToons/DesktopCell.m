//
//  DesktopIcon.m
//  NewsToons
//
//  Created by Daniela Postigo on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DesktopCell.h"
#import "Model.h"
#import "UIView+Addons.h"
#import "UIImageView+WebCache.h"

#define desktopNibWidth 280
#define slimCellWidth 100

@implementation DesktopCell {
    BOOL _showsBadge;
}

@synthesize imageView;
@synthesize divider;

@synthesize dropShadow;
@synthesize smallImageView;

@synthesize thumbnailSize;
@synthesize badge;


- (void) loadedFromNib {
    [super loadedFromNib];
    self.badge = [[[BadgeView alloc] initWithFrame: CGRectMake(0, 0, 50, 20)] autorelease];
    badge.hidden = YES;
    [self addSubview: badge];
}




#pragma mark Getters

- (void) setToonObject: (Toon *) value {
    if (value != toonObject) {
        [value retain];
        [toonObject release];
        toonObject = value;
        toonTitle.text = toonObject.title;
        toonDate.text = toonObject.date;

        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.imageView setImageWithURL: toonObject.youtubeThumbnail];

        self.badge.left = self.imageView.left + 2;
        self.badge.top = self.imageView.height - 2 - self.badge.height/2;
        [self addSubview: self.badge];
    }
}




#pragma mark Setters



- (void) handleThumbnail {
	
	SEL selector = NULL;
    selector = @selector(smallThumbnail);

	[self performSelectorInBackground:selector withObject:nil];
}




- (void) smallThumbnail {
    UIImage *toonImage = [[Model sharedModel] loadOptimizedImageFromString:[toonObject.youtubeThumbnail absoluteString] width: 285 ];
    self.imageView.clipsToBounds = YES;
	self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = toonImage;
}

- (void) miniThumbnail {
	UIImage *toonImage = [[Model sharedModel] loadOptimizedImageFromString:[toonObject.youtubeThumbnail absoluteString] width: slimCellWidth];
    self.imageView.clipsToBounds = YES;
	self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.image = toonImage;
}


- (void) mediumThumbnail {
	UIImage *toonImage = [[Model sharedModel] loadOptimizedImageFromString:[toonObject.youtubeThumbnail absoluteString] width:150];
    self.smallImageView.clipsToBounds = YES;
	self.smallImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.smallImageView.image = toonImage;
    //[self.smallImageView release];
	
    [self.imageView removeFromSuperview];
    //[self.imageView release];
	
    self.dropShadow.image = [UIImage imageNamed:@"block-cell-shadow-small.png"];
    //[self.smallImageView setContentMode:UIViewContentModeScaleAspectFit];
    //[toonImage release];
}

- (void) largeThumbnail {
	UIImage *toonImage = [[Model sharedModel] loadOptimizedImageFromString:[toonObject.youtubeThumbnail absoluteString] width:235];
	self.smallImageView.clipsToBounds = YES;
	self.smallImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.smallImageView.image = toonImage;
    //[self.imageView release];
	
    //[self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    //[toonImage release];
}


- (CGFloat) width; {
	return divider.frame.size.width;
}



- (void) setWidth: (CGFloat) w {

	
	divider.frame = CGRectMake(divider.frame.origin.x, 
							   divider.frame.origin.y, 
							   w, 
							   divider.frame.size.height);
	
	toonTitle.frame = CGRectMake(toonTitle.frame.origin.x,
								 toonTitle.frame.origin.y,
								 w - toonTitle.frame.origin.x, 
								 toonTitle.frame.size.height);
}


- (void) dealloc {
    [toonTitle release];
    [toonDate release];
    [dropShadow release];
    [toonObject release];
    [badge release];
    [imageView release];
    [divider release];
    [super dealloc];
}



@end
