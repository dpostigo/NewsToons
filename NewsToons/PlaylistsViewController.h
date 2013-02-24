//
//  PlaylistsViewController.h
//  NewsToons
//
//  Created by Daniela Postigo on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"
#import "Playlist.h"
#import "SplashView.h"

@interface PlaylistsViewController : BasicViewController <UITableViewDataSource, UITableViewDelegate> {

	SplashView *splash;
    NSMutableArray * tableSource;
}

@property(nonatomic, retain) SplashView *splash;
@property(nonatomic, retain) NSMutableArray *tableSource;

@end
