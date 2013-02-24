//
//  Model.h
//  NewsToons
//
//  Created by Daniela Postigo on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Toon.h"
#import "ToonLibrarySortMode.h"
#import "Playlist.h"
#import "Facebook.h"
#import "BasicLibrary.h"


@interface Model : BasicLibrary {

    UIImage * background;

    NSMutableArray * toonLibrary;
    NSMutableArray * bestLibrary;
    NSMutableArray * playlists;
    NSMutableArray * categories;

    BOOL needsUpdate;
    BOOL isLoadingMore;
    BOOL shouldUpdatePlaylists;

    NSDate *feedDate;
    NSString * youtubeResultsCount;
    NSString *lastDate;

    NSOperationQueue * cloudQueue;
}

@property ( nonatomic ) NSInteger  currentFeedPage;

@property ( nonatomic ) BOOL needsUpdate;
@property ( nonatomic ) BOOL isLoadingMore;
@property ( nonatomic ) BOOL shouldUpdatePlaylists;

@property ( nonatomic, retain ) Facebook * facebook;
@property ( nonatomic, retain ) NSOperationQueue * cloudQueue;
@property ( nonatomic, retain ) NSDate * feedDate;
@property ( nonatomic, retain ) NSString * lastDate;
@property ( nonatomic, retain ) NSString * youtubeResultsCount;

@property ( nonatomic, retain ) NSMutableArray * toonLibrary;
@property ( nonatomic, retain ) NSMutableArray * playlists;
@property ( nonatomic, retain ) NSMutableArray * bestLibrary;
@property ( nonatomic, retain ) NSMutableArray * tempBestToons;
@property ( nonatomic, retain ) NSMutableArray * emailedLibrary;
@property(nonatomic) BOOL shouldSupportLandscape;
+ (Model *) sharedModel;

- (void) unarchive;
- (void) archive;
- (NSMutableArray *) favoriteToons;
- (NSMutableArray *) toonsSortedBy: (ToonLibrarySortMode) sortMode;
- (void) setYoutubeValues;
- (void) addFavorite: (NSNotification *) notif;
- (void) removeFavorite: (NSNotification *) notif;


- (UIImageView *) getLogoView;


- (void) quickNoticeWithString: (NSString *) string;
- (void) quickNoticeWithString: (NSString *) string waitUntilDone: (BOOL) b;


//- (NSURL *) urlFromString: (NSString *) string;
//- (UIImage *) thumbnailFromString: (NSString *) string;
//- (UIImage *) optimizedImageFromURL: (NSURL *) imageURL;

- (UIImage *) loadOptimizedImageFromString: (NSString *) string width: (CGFloat) aWidth;
- (UIImage *) loadOptimizedImageFromURL: (NSURL *) imageURL;
- (UIImage *) loadOptimizedImageFromString: (NSString *) urlString height: (CGFloat) aHeight;
//- (UIImage *) loadOptimizedImageFromURL: (NSURL *) imageURL;
//- (UIImage *) loadOptimizedImageFromURL: (NSURL *) imageURL width: (CGFloat) aWidth;
- (UIImage *) optimizeImage: (UIImage *) image;
- (UIImage *) loadOptimizedImageFromURL: (NSURL *) imageURL width: (CGFloat) aWidth;

- (UIImage *) optimizedImage: (NSString *) urlString toWidth: (CGFloat) zWidth;
- (UIImage *) imageFromURL: (NSURL *) imageURL;
- (UIImage *) optimizeImage: (UIImage *) image width: (CGFloat) aWidth;
- (UIImage *) cropImage: (UIImage *) image toWidth: (CGFloat) zWidth;


- (NSMutableArray *) getRelatedToons: (Toon *) toon;
- (UIImage *) getPressIcon: (NSString *) string;



- (void) getEmailedToons;


@end
