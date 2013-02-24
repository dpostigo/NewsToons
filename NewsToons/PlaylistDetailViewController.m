//
//  PlaylistDetailViewController.h
//  
//  Created by Dani Postigo on 4/16/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "PlaylistDetailViewController.h"
#import "UIView+Addons.h"
#import "PlaylistCell.h"
#import "UIView+Toons.h"
#import "GlassButton.h"
#import "ToonDisplayViewController.h"
#import "Model.h"
#import "NSMutableArray+Toon.h"

@interface PlaylistDetailViewController ()

@end

@implementation PlaylistDetailViewController {
    PlaylistCell *footer;
    YoutubeView *youtubeView;
    GlassButton *moreButton;
    UIButton *titleButton;
}

@synthesize playlist;

- (id) initWithPlaylist: (Playlist *) aPlaylist {
    self = [super init];
    if (self) {

        playlist = [aPlaylist retain];

        youtubeView = [[YoutubeView alloc] initWithFrame: CGRectMake(0, 0, self.view.width, 200)];
        //[youtubeView loadVideo: playlist.selectedToon.youtubeId];


        footer = [[PlaylistCell alloc] initWithPlaylist: playlist];
        footer.top = youtubeView.top + youtubeView.height + 30;
        footer.titleLabel.centerX = footer.centerX;
        footer.titleLabel.textAlignment = UITextAlignmentCenter;
        footer.titleLabel.font = [UIFont boldSystemFontOfSize: 14.0];
        footer.titleLabel.text = playlist.selectedToon.title;
        footer.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
        footer.titleLabel.width = footer.titleLabel.width - 80;
        footer.titleLabel.centerX = footer.width / 2;
        [footer addSubview: footer.prevButton];

        [self refreshVideo];

        [footer.prevButton addTarget: self action: @selector(handlePrevNext:) forControlEvents: UIControlEventTouchUpInside];
        [footer.nextButton addTarget: self action: @selector(handlePrevNext:) forControlEvents: UIControlEventTouchUpInside];

        titleButton = [[UIButton alloc] initWithFrame: footer.titleLabel.frame];
        [titleButton addTarget: self action: @selector(handleMoreInfo) forControlEvents: UIControlEventTouchUpInside];
        [footer addSubview: titleButton];

        moreButton = [[GlassButton alloc] initWithFrame: CGRectMake(0, 0, 110, 30)];
        moreButton.color = [UIColor blackColor];
        moreButton.text = @"about this toon";
        moreButton.top = youtubeView.top + youtubeView.height + 5;
        moreButton.left = self.view.width - moreButton.width;
        [moreButton addTarget: self action: @selector(handleMoreInfo) forControlEvents: UIControlEventTouchUpInside];

        [self.view addSubview: youtubeView];
        [self.view addSubview: footer];
        [self.view addSubview: moreButton];

        UIImageView *background = [self.view quickBackgroundImage];
        [self.view insertSubview: background atIndex: 0];
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear: (BOOL) animated {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);
    [super viewWillAppear: animated];

    self.title = playlist.title;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
}

- (void) dealloc {
    //[footer.prevButton removeTarget: self action: @selector(handlePrevNext:) forControlEvents: UIControlEventTouchUpInside];
    //[footer.nextButton removeTarget: self action: @selector(handlePrevNext:) forControlEvents: UIControlEventTouchUpInside];
    [titleButton removeTarget: self action: @selector(handleMoreInfo) forControlEvents: UIControlEventTouchUpInside];
    [moreButton removeTarget: self action: @selector(handleMoreInfo) forControlEvents: UIControlEventTouchUpInside];

    [titleButton release];
    [playlist release];
    [youtubeView release];
    [moreButton release];
    [footer release];

    [super dealloc];
}

- (void) refreshVideo {
    [youtubeView loadVideo: playlist.selectedToon.youtubeId];

    footer.titleLabel.text = playlist.selectedToon.title;

    NSLog(@"playlist.selectedToon.title = %@", playlist.selectedToon.title);

    UIButton *selectedButton = [footer.buttons objectAtIndex: playlist.selectedToonIndex];

    [UIView animateWithDuration: 0.25 animations: ^{
        for (UIButton *button in footer.buttons) {

            button.alpha = 0.5;
            if (button == selectedButton) button.alpha = 1;
        }
    }];

    [footer.thumbScroller scrollRectToVisible: selectedButton.frame animated: YES];

    //if (selectedButton.left > foot)
    //footer.thumbScroller.contentOffset = CGPointMake(selectedButton.left, footer.thumbScroller.contentOffset.y);
}

- (void) handleMoreInfo {



    Toon *toonToDisplay = [_model.toonLibrary toonFromTitle: playlist.selectedToon.title];


    if (toonToDisplay == nil) {
        toonToDisplay = playlist.selectedToon;
    }


    ToonDisplayViewController *controller = [[[ToonDisplayViewController alloc] init] autorelease];
    controller.toonObject = toonToDisplay;
    [self.navigationController pushViewController: controller animated: YES];
}

- (void) handlePrevNext: (id) sender {
    if (sender == footer.prevButton) {
        if (playlist.selectedToonIndex > 0) playlist.selectedToonIndex--;
    }

    else if (sender == footer.nextButton) {

        NSLog(@"playlist.selectedToonIndex = %i", playlist.selectedToonIndex);
        NSLog(@"[playlist.toons count] = %u", [playlist.toons count]);
        if (playlist.selectedToonIndex < [playlist.toons count] - 1) {
            playlist.selectedToonIndex++;
        }
        else {
            playlist.selectedToonIndex = 0;
        }
    }

    [self refreshVideo];
}

@end