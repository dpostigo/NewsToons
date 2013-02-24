//
//  PlaylistDetailViewController.h
//  
//  Created by Dani Postigo on 4/16/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import <Foundation/Foundation.h>
#import "BasicViewController.h"
#import "Playlist.h"


@interface PlaylistDetailViewController : BasicViewController {

    Playlist *playlist;
}

@property ( nonatomic, retain ) Playlist * playlist;

- (id) initWithPlaylist: (Playlist *) aPlaylist;
- (void) refreshVideo;
- (void) handleMoreInfo;


@end