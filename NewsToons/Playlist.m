//
//  Playlist.h
//  
//  Created by Dani Postigo on 3/30/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "Playlist.h"


@implementation Playlist {

}

@synthesize title;
@synthesize playlistId;
@synthesize videoIds;
@synthesize toons;
@synthesize countHint;
@synthesize selectedToonIndex;
@synthesize categoryCount;


- (id) init {
    self = [super init];
    if ( self ) {
        NSLog(@"Playlist init");
        videoIds = [[NSMutableArray alloc] init];
        toons = [[NSMutableArray alloc] init];

    }
    return self;
}


- (id) initWithCoder: (NSCoder *) decoder {
    self = [super init];

    if ( self ) {

        self.title = [decoder decodeObjectForKey: @"title"];
        self.playlistId = [decoder decodeObjectForKey: @"playlistId"];
        self.videoIds = [decoder decodeObjectForKey: @"videoIds"];
        self.toons = [decoder decodeObjectForKey: @"toons"];
        self.selectedToonIndex = [decoder decodeIntegerForKey: @"selectedToonIndex"];
    }
    return self;

}


- (void) encodeWithCoder: (NSCoder *) encoder {

    [encoder encodeObject: title forKey: @"title"];
    [encoder encodeObject: playlistId forKey: @"playlistId"];
    [encoder encodeObject: videoIds forKey: @"videoIds"];
    [encoder encodeObject: toons forKey: @"toons"];
    [encoder encodeInteger: selectedToonIndex forKey: @"selectedToonIndex"];



}


- (void) dealloc {
    [title release];
    [playlistId release];
    [videoIds release];
    [toons release];
    [super dealloc];
}


- (Toon *) selectedToon {
    return [toons objectAtIndex: selectedToonIndex];
}

@end