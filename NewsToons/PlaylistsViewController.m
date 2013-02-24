//
//  PlaylistsViewController.m
//  NewsToons
//
//  Created by Daniela Postigo on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//




#import "PlaylistsViewController.h"
#import "Model.h"
#import "SplashView.h"
#import "UIView+Addons.h"
#import "PlaylistCell.h"
#import "PlaylistDetailViewController.h"
#import "UIView+Toons.h"
#import "NSObject+Utility.h"
#import "UIImage+Addons.h"
#import "ParsePlaylistFeed.h"
#import "CheckPlaylistUpdates.h"

@interface PlaylistsViewController ()

- (void) handlePlaylistsLoaded;


@end

@implementation PlaylistsViewController {
    UITableView * table;

    PlaylistDetailViewController * controller;
    BOOL playlistsLoaded;
}

@synthesize splash;
@synthesize tableSource;


- (void) dealloc {
    table.delegate = nil;
    [table release];
    [tableSource release];
    [_queue release];
    if (controller) [controller release];
    [splash release];
    [super dealloc];
}





- (void) viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;

}




- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

    NSOperation * operation = [[[CheckPlaylistUpdates alloc] init] autorelease];
    [_queue addOperation: operation];

    operation = [[[ParsePlaylistFeed alloc] initWithFeedURL: [NSURL URLWithString: YOUTUBE_URL_PLAYLISTS]] autorelease];
    [_queue addOperation: operation];

    //table.allowsSelection = NO;
}


- (void) viewWillAppear: (BOOL) animated {
    self.navigationController.navigationBarHidden = YES;
    [super viewWillAppear: animated];
}



- (void) awakeFromNib {
    [super awakeFromNib];

    self.title = @"Playlists";
    self.tableSource = [[[NSMutableArray alloc] init] autorelease];

    table = [[UITableView alloc] init];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor clearColor];
    table.backgroundView.backgroundColor = [UIColor clearColor];
    table.separatorColor = [UIColor clearColor];
    table.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview: table];
    table.frame = self.view.frame;
    table.top = 70;
    table.height = table.height - 70 - 50;

    [self handleBackground];


    if ( [self.model.playlists count] == 0 ) {
        [self createSplashView];


    } else {
        if ( !playlistsLoaded) {
            playlistsLoaded = YES;
            [self refreshTable];
            [splash removeFromSuperview];
        }
    }

}


#pragma mark UI Creation -


- (void) createSplashView {
    self.splash = [[[SplashView alloc] initWithFrame: self.view.bounds] autorelease];
    splash.label.text = @"Loading playlists from YouTube...";

    UIImageView * icon = [[[UIImageView alloc] initWithImage: [[UIImage newImageFromResource: @"youtube_icon.png"] autorelease]] autorelease];
    [splash addSubview: icon];
    splash.circle.left = splash.label.left + (splash.label.width/2) + 10;
    icon.right = splash.circle.left - 10;

    icon.centerY = splash.circle.centerY;
    [self.view addSubview: splash];
    [self addSelector: @selector(handlePlaylistsLoaded) name: playlistFeedParsed withObject: nil];



}

#pragma mark Loading


- (void) handlePlaylistsLoaded {

    playlistsLoaded = YES;
    [self removeSelector: playlistFeedParsed];
    if ( splash.isVisible && !splash.isAnimating ) {

        [splash fadeOut];
        [splash release];
    }
    [self refreshTable];
}


- (void) refreshTable {


    self.tableSource = [[[NSMutableArray alloc] init] autorelease];
    [tableSource addObjectsFromArray: self.model.playlists];
    [table reloadData];

}




#pragma mark TableView



- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

    Playlist * playlist = [tableSource objectAtIndex: indexPath.row];
    NSString * identifier = [NSString stringWithFormat: @"playlist-cell-%@", playlist.playlistId];

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    if ( cell == nil ) {

        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: identifier] autorelease];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = [[[UIView alloc] init] autorelease];
        cell.contentView.backgroundColor = [UIColor clearColor];

        cell.textLabel.font = [UIFont boldSystemFontOfSize: 11.0];
        cell.textLabel.text = playlist.title;
        cell.textLabel.alpha = 0;
        cell.textLabel.textColor = [UIColor whiteColor];



        PlaylistCell * subCell = [[[PlaylistCell alloc] initWithPlaylist: playlist] autorelease];
        [cell addSubview: subCell];
        cell.contentView.width = subCell.width;
        cell.contentView.height = subCell.height;
    }
    return cell;
}


- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
    return tableSource.count;

}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

    Playlist * playlist = [tableSource objectAtIndex: (NSUInteger) indexPath.row];


    /*
    if ( ! controller ){
        controller = [[PlaylistDetailViewController alloc] initWithPlaylist: playlist];


    } else {
        if ( controller.playlist != playlist ) {
            [controller release], controller = nil;
            controller = [[PlaylistDetailViewController alloc] initWithPlaylist: playlist];
        }
    }
    */

    PlaylistDetailViewController * c = [[PlaylistDetailViewController alloc] initWithPlaylist: playlist];

    [self.navigationController pushViewController: c animated: YES];
}



- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    return 120;
}


#pragma mark Misc methods

- (void) fadeSplash {

    splash.circle.twirlMode = NO;
    splash.isAnimating = YES;

    [UIView animateWithDuration: 0.5 animations: ^ {
        splash.circle.alpha = 0;
    }];


    [UIView animateWithDuration: 0.5 delay: 0.25 options: UIViewAnimationOptionCurveEaseOut animations: ^ {
        splash.label.alpha = 0;
    }                completion: ^ (BOOL finished) {

    }];


    [UIView animateWithDuration: 0.5 delay: 0.75 options: UIViewAnimationOptionCurveEaseOut animations: ^ {
        splash.alpha = 0;
    }                completion: ^ (BOOL finished) {
        splash.isVisible = false;
    }];


}

- (void) handleBackground {
    UIImageView * background = [self.view logoBackground];
    [self.view insertSubview: background atIndex: 0];
    self.view.backgroundColor = [UIColor blackColor];
}

@end
