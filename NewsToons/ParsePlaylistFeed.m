//
//  PlaylistFeedOperation.h
//  
//  Created by Dani Postigo on 3/30/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "ParsePlaylistFeed.h"
#import "Model.h"
#import "Playlist.h"
#import "ParsePlaylistToons.h"
#import "PlaylistQueue.h"
#import "NSMutableArray+Toon.h"

#define entryNode @"entry"
#define ytPlaylistId @"yt:playlistId"
#define ytCountHint @"yt:countHint"
#define titleNode @"title"

@implementation ParsePlaylistFeed {
    Playlist *currentPlaylist;
    NSMutableArray *_newPlaylists;
}

- (NSMutableArray *) nodes {
    if (!nodes) {
        nodes = [[NSMutableArray alloc] initWithObjects: entryNode, ytPlaylistId, titleNode, nil];
    }

    return nodes;
}

- (void) main {

    if (_model.shouldUpdatePlaylists) {

        NSLog(@"parsing playlists");
        _newPlaylists = [[NSMutableArray alloc] init];
        parsedData = [NSMutableString string];
        [_xmlParser parse];

        parsedData = nil;
        _xmlParser.delegate = nil, [_xmlParser release];
        [nodes release];
        [_newPlaylists release];
    } else {

        NSLog(@"not parsing");
    }
}

- (void) parser: (NSXMLParser *) parser didStartElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName attributes: (NSDictionary *) attributeDict {

    if ([elementName isEqualToString: entryNode]) {
        currentPlaylist = [[Playlist alloc] init];
    }

    else if ([elementName isEqualToString: titleNode]) {
        [self startParsingData];
    }

    else if ([elementName isEqualToString: ytPlaylistId]) {
        [self startParsingData];
    }
    else if ([elementName isEqualToString: ytCountHint]) {
        [self startParsingData];
    }
}

- (void) parser: (NSXMLParser *) parser didEndElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName {

    if ([elementName isEqualToString: @"feed"]) {

        /*      PLAYLIST PARSING COMPLETED    */

        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"countHint > 0"];
        [_newPlaylists filterUsingPredicate: predicate];

        predicate = [NSPredicate predicateWithFormat: @"categoryCount > 1"];
        [_newPlaylists filterUsingPredicate: predicate];

        NSMutableArray *operations = [[[NSMutableArray alloc] init] autorelease];

        [_newPlaylists enumerateObjectsUsingBlock: ^(Playlist *playlist, NSUInteger index, BOOL *stop) {
            NSString *playlistId = [[[NSString alloc] initWithString: playlist.playlistId] autorelease];
            NSString *feedURL = [[[NSString alloc] initWithFormat: @"%@%@?v=2", singlePlaylistURL, playlistId] autorelease];
            ParsePlaylistToons *operation = [[[ParsePlaylistToons alloc] initWithFeedURL: [NSURL URLWithString: feedURL]] autorelease];
            operation.playlist = playlist;
            [operations addObject: operation];
        }];

        [[NSOperationQueue currentQueue] addOperations: operations waitUntilFinished: YES];

        for (Playlist *playlist in _newPlaylists) {
            [playlist.toons enumerateObjectsUsingBlock: ^(Toon *toon, NSUInteger index, BOOL *stop) {
                NSLog(@"Model contains playlist toon ? %d", [_model.toonLibrary containsObject: toon]);
            }];
        }

        for (Playlist *playlist in _newPlaylists) {

            [playlist.toons enumerateObjectsUsingBlock: ^(Toon *toon, NSUInteger index, BOOL *stop) {
                if ([_model.toonLibrary containsToon: toon]) {
                    NSLog(@"Library contains - %@", toon.title);
                    Toon *libraryToon = [_model.toonLibrary toonFromTitle: toon.title];
                    toon = libraryToon;
                    //[playlist.toons replaceObjectAtIndex: index withObject: libraryToon];

                } else {
                    toon.nid = toon.youtubeId;
                    [_model.toonLibrary addToon: toon];
                }
            }];

            _model.playlists = _newPlaylists;
        }

        [[NSOperationQueue currentQueue] addOperationWithBlock: ^() {
            NSLog(@"ALL FINISHED");
            [_model archive];
            [_model quickNoticeWithString: playlistFeedParsed];
        }];
    }

    if ([elementName isEqualToString: entryNode]) {
        [_newPlaylists addObject: currentPlaylist];
        [currentPlaylist release], currentPlaylist = nil;
    }

    else if ([elementName isEqualToString: titleNode]) {
        if (currentPlaylist)
            currentPlaylist.title = [[[NSString alloc] initWithString: parsedData] autorelease];
    }

    else if ([elementName isEqualToString: ytPlaylistId]) {
        currentPlaylist.playlistId = [[[NSString alloc] initWithString: parsedData] autorelease];
    }

    else if ([elementName isEqualToString: ytCountHint]) {
        currentPlaylist.countHint = [parsedData integerValue];
    }

    else if ([elementName isEqualToString: @"category"]) {
        currentPlaylist.categoryCount++;
    }

    isParsing = NO;
}

- (void) finish {
}

- (void) dealloc {
    [currentPlaylist release];
    [super dealloc];
}

@end