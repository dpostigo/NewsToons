//
//  Playlist.h
//  
//  Created by Dani Postigo on 3/30/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import <Foundation/Foundation.h>
#import "Toon.h"


@interface Playlist : NSObject <NSCoding> {

    NSString *title;
    NSString *playlistId;

    NSMutableArray * videoIds;
    NSMutableArray * toons;

    NSInteger countHint;

    NSInteger selectedToonIndex;

    NSInteger categoryCount;
}

@property ( nonatomic, retain ) NSString * title;
@property ( nonatomic, retain ) NSString * playlistId;
@property ( nonatomic, retain ) NSMutableArray * videoIds;
@property ( nonatomic, retain ) NSMutableArray * toons;
@property ( nonatomic ) NSInteger countHint;
@property ( nonatomic ) NSInteger selectedToonIndex;
@property ( nonatomic ) NSInteger categoryCount;


- (Toon *) selectedToon;


@end