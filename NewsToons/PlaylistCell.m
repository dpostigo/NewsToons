//
//  PlaylistCell.h
//  
//  Created by Dani Postigo on 4/16/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import <QuartzCore/QuartzCore.h>
#import "PlaylistCell.h"
#import "UIView+Addons.h"
#import "Model.h"
#import "UIImage+Addons.h"
#import "NSObject+Utility.h"
#import "PlaylistDetailViewController.h"

#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "GlassButton.h"

@interface PlaylistCell ()

@end

@implementation PlaylistCell {
}

@synthesize titleLabel;
@synthesize imageRef;
@synthesize titleBackground;
@synthesize playlist;
@synthesize thumbScroller;
@synthesize showsSelectedToon;
@synthesize buttons;
@synthesize nextButton;
@synthesize prevButton;


- (void) dealloc {
    [self clearButtons];
    [self removeSelector: singlePlaylistUpdated];
    [titleLabel release];

    [imageRef release];
    [playlist release];
    [titleBackground release];
    [thumbScroller release];


    [nextButton release];
    [prevButton release];
    [buttons release];

    [super dealloc];
}


- (void) handlePlaylist {
    titleLabel.text = playlist.title;
    [self createThumbScroller];
}


- (id) initWithPlaylist: (Playlist *) aPlaylist {
    self = [super initWithFrame: CGRectMake(0, 0, 320, 120)];
    if (self) {
        showsSelectedToon = NO;
        playlist = [aPlaylist retain];
        self.backgroundColor = [UIColor clearColor];
        [self handlePlaylist];
        [self addHitAreas];
        [self addSelector: @selector(updateSinglePlaylist:) name: singlePlaylistUpdated withObject: self.playlist];
    }
    return self;
}


- (void) addHitAreas {
    [self createNextButton];
    [self createPreviousButton];
}


- (void) createNextButton {
    UIImage *image = [[UIImage newImageFromResource: @"arrow_next.png"] autorelease];
    nextButton = [[UIButton buttonWithType: UIButtonTypeCustom] retain];
    [nextButton setImage: image forState: UIControlStateNormal];
    nextButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    nextButton.left = self.width - nextButton.width + 3;
    nextButton.top = 5;
    [self addSubview: nextButton];
}

- (void) createPreviousButton {
    UIImage *image = [[UIImage newImageFromResource: @"arrow_previous.png"] autorelease];
    prevButton = [[UIButton buttonWithType: UIButtonTypeCustom] retain];
    [prevButton setImage: image forState: UIControlStateNormal];
    prevButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    prevButton.top = 5;
    //[self addSubview: prevButton];
}


- (void) setPlaylist: (Playlist *) aPlaylist {
    if (playlist != aPlaylist) {
        [aPlaylist retain], [playlist release];
        playlist = aPlaylist;
        nextButton.hidden = ([playlist.toons count] == 1);

    }

    [self createThumbScroller];
}


- (void) updateSinglePlaylist: (NSNotification *) notification {
    [self createThumbScroller];
}


- (void) createThumbScroller {

    if (thumbScroller != nil) [thumbScroller removeFromSuperview];

    self.thumbScroller = [[[UIScrollView alloc] initWithFrame: CGRectMake(0, 0, self.width, 80)] autorelease];
    NSLog(@"NSStringFromCGRect(thumbScroller.frame) = %@", NSStringFromCGRect(thumbScroller.frame));

    UIView *thumbsView = [self createThumbsView];
    [thumbScroller addSubview: thumbsView];

    thumbScroller.width = self.width;
    thumbScroller.height = thumbsView.height;
    thumbScroller.left = 0;
    thumbScroller.top = imageRef.top;
    thumbScroller.scrollEnabled = YES;
    thumbScroller.showsHorizontalScrollIndicator = NO;
    thumbScroller.contentSize = CGSizeMake(thumbsView.width, thumbsView.height);
    NSLog(@"thumbScroller.contentSize.width = %f", thumbScroller.contentSize.width);

    [subview insertSubview: thumbScroller belowSubview: titleBackground];
}


- (void) clearButtons {
    for (UIButton *button in buttons) {
        [button removeTarget: self action: @selector(handleButtonTouchDown:) forControlEvents: UIControlEventTouchDown];
        [button removeTarget: self action: @selector(handleButtonTouchUp:) forControlEvents: UIControlEventTouchUpInside];
        [button removeFromSuperview];
    }
}


- (void) addButtons {
    self.buttons = [[[NSMutableArray alloc] init] autorelease];
    BOOL hasToons = ([playlist.toons count] > 0);
    [playlist.toons enumerateObjectsUsingBlock: ^(Toon *toon, NSUInteger index, BOOL *stop) {

        UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
        button.frame = imageRef.frame;
        button.contentMode = UIViewContentModeScaleAspectFill;
        button.clearsContextBeforeDrawing = YES;
        button.autoresizesSubviews = NO;

        button.opaque = NO;
        button.backgroundColor = [UIColor colorWithWhite: 0.0 alpha: 1.0];
        button.layer.borderWidth = 1.0;
        button.layer.borderColor = [UIColor blackColor].CGColor;


        if (hasToons) {
            Toon *toon = [playlist.toons objectAtIndex: index];
            [button setImageWithURL: toon.youtubeThumbnail];

            if (showsSelectedToon && playlist.selectedToon == toon) {
                button.layer.borderWidth = 2.0;
                button.layer.borderColor = [UIColor colorWithWhite: 1.0 alpha: 0.5].CGColor;
            }
        }

        button.tag = index;
        button.left = index * (imageRef.width - 5);
        button.top = 0;
        [button addTarget: self action: @selector(handleButtonTouchDown:) forControlEvents: UIControlEventTouchDown];
        [button addTarget: self action: @selector(handleButtonTouchUp:) forControlEvents: UIControlEventTouchUpInside];

        NSLog(@"Added target");
        [buttons addObject: button];
    }];
}


- (UIView *) createThumbsView {

    if (buttons != nil)  [self clearButtons];


    UIView *thumbsView = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, self.width, 80)] autorelease];

    [self addButtons];
    for (UIButton *button in buttons) {
        [thumbsView addSubview: button];
    }

    UIButton *lastButton = [buttons lastObject];

    thumbsView.width = lastButton.left + lastButton.width;
    thumbsView.height = lastButton.height;
    thumbsView.left = 0;
    thumbsView.top = 0;
    [thumbsView rasterize];

    if (imageRef.superview) [imageRef removeFromSuperview];
    return thumbsView;
}


- (void) handleButtonTouchDown: (id) sender {

    NSInteger index = [sender tag];
    playlist.selectedToonIndex = index;

    UIButton *senderButton = sender;

    if (showsSelectedToon) {
        for (UIButton *button in buttons) {
            button.layer.borderWidth = 1.0;
            button.layer.borderColor = [UIColor blackColor].CGColor;
        }

        senderButton.layer.borderWidth = 2.0;
        senderButton.layer.borderColor = [UIColor colorWithWhite: 1.0 alpha: 1.0].CGColor;
    }
}


- (void) handleButtonTouchUp: (id) sender {


    if ([self.nextResponder isKindOfClass: [UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell *) self.nextResponder;
        UITableView *table = (UITableView *) self.nextResponder.nextResponder;
        [table.delegate tableView: table didSelectRowAtIndexPath: [table indexPathForCell: cell]];
    }

    else if ([self.nextResponder.nextResponder isKindOfClass: [PlaylistDetailViewController class]]) {
        PlaylistDetailViewController *controller = (PlaylistDetailViewController *) self.nextResponder.nextResponder;
        [controller refreshVideo];
    }
}

@end