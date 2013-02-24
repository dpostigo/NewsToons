//
//  PlaylistCell.h
//  
//  Created by Dani Postigo on 4/16/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import <Foundation/Foundation.h>
#import "BasicNibView.h"
#import "Playlist.h"
#import "GlassButton.h"



@interface PlaylistCell : BasicNibView {
    Playlist *playlist;

    IBOutlet UILabel *titleLabel;
    IBOutlet UIImageView *imageRef;
    IBOutlet UIImageView *titleBackground;

    UIScrollView *thumbScroller;
    BOOL showsSelectedToon;

    NSMutableArray * buttons;
    UIButton * nextButton;
    UIButton * prevButton;

}

@property ( nonatomic, retain ) UILabel * titleLabel;
@property ( nonatomic, retain ) UIImageView * imageRef;
@property ( nonatomic, retain ) UIImageView *titleBackground;
@property ( nonatomic, retain ) Playlist * playlist;
@property ( nonatomic, retain ) UIScrollView * thumbScroller;
@property ( nonatomic ) BOOL showsSelectedToon;
@property ( nonatomic, retain ) NSMutableArray * buttons;
@property ( nonatomic, retain ) UIButton * nextButton;
@property ( nonatomic, retain ) UIButton * prevButton;


- (id) initWithPlaylist: (Playlist *) aPlaylist;


@end