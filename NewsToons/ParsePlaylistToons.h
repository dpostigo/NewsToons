//
//  PlaylistOperation.h
//  
//  Created by Dani Postigo on 3/30/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import <Foundation/Foundation.h>
#import "FeedOperation.h"
#import "Playlist.h"


@interface ParsePlaylistToons : FeedOperation <FeedOperationProtocol> {

    Playlist *playlist;

}

@property ( nonatomic, retain ) Playlist * playlist;


@end