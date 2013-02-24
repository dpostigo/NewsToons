//
//  Model.m
//  NewsToons
//
//  Created by Daniela Postigo on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Model.h"
#import "NSString+Addons.h"
#import "UIImage+Addons.h"
#import "NSObject+Utility.h"
#import "CCRequest.h"
#import "CloudLogin.h"
#import "GetEmailedToons.h"

@implementation Model {

@private
    BOOL _shouldRate;
    CGFloat playlistCount;
    NSMutableArray * tempBestToons;
    NSMutableArray * emailedLibrary;
    BOOL _shouldSupportLandscape;
}

@synthesize toonLibrary;
@synthesize playlists;
@synthesize facebook = _facebook;
@synthesize bestLibrary;
@synthesize tempBestToons;
@synthesize emailedLibrary;
@synthesize cloudQueue;
@synthesize lastDate;
@synthesize needsUpdate;
@synthesize currentFeedPage;
@synthesize isLoadingMore;
@synthesize feedDate;
@synthesize shouldUpdatePlaylists;
@synthesize youtubeResultsCount;
@synthesize shouldSupportLandscape = _shouldSupportLandscape;


+ (Model *) sharedModel {
    static Model * _instance = nil;
    @synchronized (self) {
        if ( _instance == nil ) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}


- (id) init {
    self = [super init];
    if ( self ) {

        toonLibrary = [[NSMutableArray alloc] init];
        bestLibrary = [[NSMutableArray alloc] init];
        emailedLibrary = [[NSMutableArray alloc] init];
        playlists = [[NSMutableArray alloc] init];

        //[self getEmailedToons];

        [self addSelector: @selector(addFavorite:) name: MAKE_FAVORITE withObject: nil];
        [self addSelector: @selector(removeFavorite:) name: MAKE_UNFAVORITE withObject: nil];

        [self unarchive];

        shouldUpdatePlaylists = YES;
        NSLog(@"Model finished initing.");
    }
    return self;
}


- (void) dealloc {

    [self removeSelector: MAKE_FAVORITE];
    [self removeSelector: MAKE_UNFAVORITE];


    [[NSNotificationCenter defaultCenter] removeObserver: self name: TOONS_PARSED object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self name: PARSE_ERROR object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self name: PARSING_COMPLETE object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self];


    //[toonLibrary release];
    //[bestLibrary release];
    //[emailedLibrary release];

    [background release];
    [playlists release];
    [_facebook release];

    [lastDate release];
    [feedDate release];
    [youtubeResultsCount release];
    [toonLibrary release];
    [bestLibrary release];
    [emailedLibrary release];
    [tempBestToons release];
    [cloudQueue release];
    [super dealloc];
}



#pragma mark Archive / Unarchive

- (void) unarchive {


    _shouldRate = [[NSUserDefaults standardUserDefaults] boolForKey: @"showRate"];
    currentFeedPage = [[NSUserDefaults standardUserDefaults] integerForKey: pageStoreKey];
    
    NSLog(@"DEARCHIVED currentFeedPage = %i", currentFeedPage);
    lastDate = [[NSUserDefaults standardUserDefaults] objectForKey: lastDateKey];
    feedDate = [[NSUserDefaults standardUserDefaults] objectForKey: feedDateKey];
    youtubeResultsCount = [[NSUserDefaults standardUserDefaults] stringForKey: youtubeResultsKey];



    NSArray * toonArray;
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey: toonLibraryStoreKey];
    if ( data != nil ) {
        toonArray = [NSKeyedUnarchiver unarchiveObjectWithData: data];
        [toonLibrary addObjectsFromArray: toonArray];
        [self sortLibrary];
    }

    NSArray * bestArray;
    NSData * bestData = [[NSUserDefaults standardUserDefaults] objectForKey: bestLibraryStoreKey];
    if ( bestData != nil ) {
        bestArray = [NSKeyedUnarchiver unarchiveObjectWithData: bestData];
        [bestLibrary addObjectsFromArray: bestArray];
    }

    NSArray * playlistArray;
    NSData * playlistData = [[NSUserDefaults standardUserDefaults] objectForKey: playlistStoreKey];
    if ( playlistData != nil ) {
        playlistArray = [NSKeyedUnarchiver unarchiveObjectWithData: playlistData];
        [playlists addObjectsFromArray: playlistArray];
    }


}


- (void) archive {
    [[NSUserDefaults standardUserDefaults] setInteger: currentFeedPage forKey: pageStoreKey];

    [self sortLibrary];
    //NSLog(@"Archiving ---- toons.");
    for (Toon *toon in toonLibrary) {
        //NSLog(@"%@", toon.title);
    }
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject: toonLibrary];
    [[NSUserDefaults standardUserDefaults] setObject: data forKey: toonLibraryStoreKey];

    //NSLog(@"Archiving ---- best toons.");
    NSMutableArray *bestToons = [self toonsSortedBy: ToonLibrarySortByDate];
    NSData * bestData = [NSKeyedArchiver archivedDataWithRootObject: bestToons];
    [[NSUserDefaults standardUserDefaults] setObject: bestData forKey: bestLibraryStoreKey];

    //NSLog(@"Archiving ---- playlists.");
    NSData * playlistData = [NSKeyedArchiver archivedDataWithRootObject: playlists];
    [[NSUserDefaults standardUserDefaults] setObject: playlistData forKey: playlistStoreKey];

    //NSLog(@"Archiving ---- last date.");
    [[NSUserDefaults standardUserDefaults] setObject: lastDate forKey: lastDateKey];

    //NSLog(@"Archiving ---- feed date.");
    [[NSUserDefaults standardUserDefaults] setObject: feedDate forKey: feedDateKey];

    //NSLog(@"Archiving ---- playlist results.");
    [[NSUserDefaults standardUserDefaults] setObject: youtubeResultsCount forKey: youtubeResultsKey];



}


- (void) setYoutubeValues {
    if ( !LOAD_YOUTUBE_ON_LAUNCH ) {
        NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);

        for ( Toon * toon in toonLibrary ) {
            [toon setYoutubeValues];
            NSLog(@"Toon: %d/%d", [toonLibrary indexOfObject: toon], toonLibrary.count);
        }

    }

}



#pragma mark Sorting

- (NSMutableArray *) toonsSortedBy: (ToonLibrarySortMode) sortMode {

    //NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);

    NSString * sortKey = nil;
    switch (sortMode) {

        case ToonLibrarySortByDate :
            sortKey = @"dateObject";
            break;

        case ToonLibrarySortByViewCount:
            sortKey = @"viewCount";
            break;

        case ToonLibrarySortByEmailCount :
            sortKey = @"emailCount";
            break;

        case ToonLibrarySortByRating :
            sortKey = @"rating";
            break;

        case ToonLibrarySortByBest:
            sortKey = @"isBest";
            //NSLog(@"MODEL SORTING BY BEST");
            break;
    }

    if ( [sortKey isEqualToString: @"isBest"] ){

        NSPredicate * predicate = [NSPredicate predicateWithFormat: @"isBest == YES"];
        NSArray *filtered = [self.toonLibrary filteredArrayUsingPredicate: predicate];
        //NSLog(@"filtered = %@", filtered);
        return [[[NSMutableArray alloc] initWithArray: filtered] autorelease];

    } else {

        NSSortDescriptor * sortDescriptor = [[[NSSortDescriptor alloc] initWithKey: sortKey ascending: NO] autorelease];
        NSArray * arr = [toonLibrary sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortDescriptor]];
        return [[[NSMutableArray alloc] initWithArray: arr] autorelease];

    }


}

- (void) sortLibraryByDate {
    NSSortDescriptor * sortDescriptor = [[[NSSortDescriptor alloc] initWithKey: @"dateObject" ascending: NO] autorelease];
    NSArray * descriptors = [NSArray arrayWithObject: sortDescriptor];
    [toonLibrary sortUsingDescriptors: descriptors];
}

- (void) sortLibrary {
    [self sortLibraryByDate];
}





#pragma mark Favoriting

- (void) addFavorite: (NSNotification *) notif {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);
    NSLog(@"Toon = %@", notif.object);
    [self archive];
    [[NSNotificationCenter defaultCenter] postNotificationName: favoritesUpdatedKey object: nil];
}


- (void) removeFavorite: (NSNotification *) notif {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);
    NSLog(@"Toon = %@", notif.object);
    [self archive];
    [[NSNotificationCenter defaultCenter] postNotificationName: favoritesUpdatedKey object: nil];
}




#pragma mark Email functions





- (void) getEmailedToons {

    NSOperation * operation;

    cloudQueue = [NSOperationQueue mainQueue];

    operation = [[[CloudLogin alloc] init] autorelease];
    [cloudQueue addOperation: operation];

    operation = [[[GetEmailedToons alloc] init] autorelease];
    [cloudQueue addOperation: operation];


    /*
    NSDictionary * paramDict = [NSDictionary dictionaryWithObjectsAndKeys: @"emailedToons", @"name", nil];
    CCRequest * request = [[CCRequest alloc] initWithDelegate: self httpMethod: @"GET" baseUrl: @"keyvalues/get.json" paramDict: nil];
    [request startAsynchronous];
    [request release];
    */

}






#pragma mark Getters

/*
*
*
*

Getters

*
*
*
*/



- (NSMutableArray *) favoriteToons {
    for (Toon * toon in toonLibrary ) {
        if (toon.isFavorite)
            NSLog(@"Found favorite.");
    }


    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"isFavorite == YES"];

    NSMutableArray * array = [[[NSMutableArray alloc] initWithArray: [self.toonLibrary filteredArrayUsingPredicate: predicate]] autorelease];
    return array;
}

- (Facebook *) facebook {

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ( [defaults objectForKey: @"FBAccessTokenKey"] && [defaults objectForKey: @"FBExpirationDateKey"] ) {
        _facebook.accessToken = [defaults objectForKey: @"FBAccessTokenKey"];
        _facebook.expirationDate = [defaults objectForKey: @"FBExpirationDateKey"];
    }

    return _facebook;
}



#pragma mark Data initialization





#pragma mark Notifications


- (void) quickNoticeWithString: (NSString *) string {
    [self quickNoticeWithString: string waitUntilDone: NO];
}


- (void) quickNoticeWithString: (NSString *) string waitUntilDone: (BOOL) b {
    NSNotification * notification = [NSNotification notificationWithName: string object: nil];
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread: @selector(postNotification:) withObject: notification waitUntilDone: b];
}




#pragma mark Parse operations



#pragma mark Playlists




#pragma mark UIImage


/*

IMAGE OPTIMIZATION METHODS

*/


- (NSURL *) urlFromString: (NSString *) string {
    return [NSURL URLWithString: [string stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding]];

}


- (UIImage *) thumbnailFromString: (NSString *) string; {

    NSURL * imageURL = [self urlFromString: string];
    NSData * imageData = [NSData dataWithContentsOfURL: imageURL];
    UIImage * image = [UIImage imageWithData: imageData];
    //[imageData release];
    //[imageURL release];
    return image;

}


- (UIImage *) optimizedImage: (NSString *) urlString toWidth: (CGFloat) zWidth {

    UIImage * image = [self thumbnailFromString: urlString];

    CGFloat prop = zWidth / image.size.width;
    CGSize newSize = CGSizeMake(zWidth, image.size.height * prop);

    UIGraphicsBeginImageContext(newSize);
    [image drawInRect: CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (UIImage *) imageFromURL: (NSURL *) imageURL; {

    NSData * imageData = [NSData dataWithContentsOfURL: imageURL];
    UIImage * image = [UIImage imageWithData: imageData];
    //[imageData release];
    //[imageURL release];
    return image;

}


/*

IMAGE OPTIMIZATION METHODS

*/

- (UIImage *) optimizeImage: (UIImage *) image width: (CGFloat) aWidth {
    CGFloat prop = aWidth / image.size.width;
    CGSize newSize = CGSizeMake(aWidth, image.size.height * prop);

    UIGraphicsBeginImageContext(newSize);
    [image drawInRect: CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (UIImage *) optimizeImage: (UIImage *) image {
    return [self optimizeImage: image width: image.size.width * 2.85];
}


- (UIImage *) loadOptimizedImageFromURL: (NSURL *) imageURL width: (CGFloat) aWidth {
    UIImage * image = [self imageFromURL: imageURL];
    return [self optimizeImage: image width: aWidth];
}


- (UIImage *) loadOptimizedImageFromURL: (NSURL *) imageURL {
    UIImage * image = [self imageFromURL: imageURL];
    return [self optimizeImage: image];

}


- (UIImage *) loadOptimizedImageFromString: (NSString *) urlString height: (CGFloat) aHeight {

    UIImage * image = [self imageFromURL: [urlString toURL]];


    CGFloat prop = aHeight / image.size.height;
    CGSize newSize = CGSizeMake(image.size.width * prop, aHeight);

    UIGraphicsBeginImageContext(newSize);
    [image drawInRect: CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (UIImage *) loadOptimizedImageFromString: (NSString *) string width: (CGFloat) aWidth {
    //return [self loadOptimizedImageFromURL: [urlString toURL] width: aWidth];
    return [self optimizedImage: string toWidth: aWidth];
}


/*



- (UIImage *) loadOptimizedImageFromString: (NSString *) urlString width: (CGFloat) aWidth {
   return [self loadOptimizedImageFromURL: [urlString toURL] width: aWidth];
}


- (UIImage *) loadOptimizedImageFromString: (NSString *) urlString height: (CGFloat) aHeight {

   UIImage * image = [[UIImage newImageFromURL: [urlString toURL]] autorelease];


   CGFloat prop = aHeight / image.size.height;
   CGSize newSize = CGSizeMake(image.size.width * prop, aHeight);

   UIGraphicsBeginImageContext(newSize);
   [image drawInRect: CGRectMake(0, 0, newSize.width, newSize.height)];
   UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();
   return newImage;
}


- (UIImage *) loadOptimizedImageFromURL: (NSURL *) imageURL {
   UIImage * image = [[UIImage newImageFromURL: imageURL] autorelease];
   return [self optimizeImage: image];

}

- (UIImage *) loadOptimizedImageFromURL: (NSURL *) imageURL width: (CGFloat) aWidth {
   UIImage * image = [[UIImage newImageFromURL: imageURL] autorelease];
   return [self optimizeImage: image width: aWidth];
}



- (UIImage *) optimizeImage: (UIImage *) image {
   return [self optimizeImage: image width: image.size.width * 2.85];

}


- (UIImage *) optimizeImage: (UIImage *) image width: (CGFloat) aWidth {
   CGFloat prop = aWidth / image.size.width;
   CGSize newSize = CGSizeMake(aWidth, image.size.height * prop);

   UIGraphicsBeginImageContext(newSize);
   [image drawInRect: CGRectMake(0, 0, newSize.width, newSize.height)];
   UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();
   return newImage;
}



*/


- (UIImage *) cropImage: (UIImage *) image toWidth: (CGFloat) zWidth {

    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(( image.size.width - zWidth ) / 2, 0, zWidth, image.size.height));
    UIImage * newImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    return newImage;

}


- (UIImageView *) getLogoView {

    UIImage * image = [[UIImage newImageFromResource: @"ipad-logo-small.png"] autorelease];
    UIImageView * imageView = [[[UIImageView alloc] initWithImage: image] autorelease];
    imageView.frame = CGRectMake(30, 30, imageView.frame.size.width, imageView.frame.size.height);
    return imageView;
}


- (void) saveCategories {
    NSLog(@"Saving categories.");
    [[NSUserDefaults standardUserDefaults] setObject: categories forKey: CATEGORY_STORE_KEY];


}

- (void) handleCategories: (NSMutableArray *) array; {
    if ( !categories )
        categories = [[NSMutableArray alloc] init];

    for ( NSString * cat in array ) {
        if ( ![categories containsObject: cat] )
            [categories addObject: cat];
    }
}


- (NSMutableArray *) categories {
    if ( !categories ) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        categories = [defaults objectForKey: CATEGORY_STORE_KEY];
    }
    return categories;
}

- (void) setCategories: (NSMutableArray *) val {
    if ( val != categories ) {
        [val retain];
        [categories release];
        categories = val;
    }
}


- (NSMutableArray *) getRelatedToons: (Toon *) toon {
    toon.relatedToons = [[toonLibrary subarrayWithRange: NSMakeRange(0, 10)] mutableCopy];
    //NSLog(@"toon.relatedToons = %@", toon.relatedToons);
    return toon.relatedToons;
}


- (UIImage *) getPressIcon: (NSString *) string; {

    NSString * imgName = @"globe-icon.png";
    if ( [string containsString: @"nytimes.com"] ) {
        imgName = @"nytimes-icon.png";
    }

    else if ( [string isEqualToString: @"salon.com"] ) {
        imgName = @"salon-icon.png";
    }

    else if ( [string isEqualToString: @"washingtonpost.com"] ) {
        imgName = @"washington-post.png";
    }

    else if ( [string isEqualToString: @"boingboing.net"] ) {
        imgName = @"boingboing-icon.png";
    }

    else if ( [string isEqualToString: @"wired.com"] ) {
        imgName = @"wired-icon.png";
    }
    else if ( [string isEqualToString: @"buzzfeed.com"] ) {
        imgName = @"buzzfeed-icon.png";
    }
    else if ( [string isEqualToString: @"forbes.com"] ) {
        imgName = @"forbes-icon.png";
    }

    return [UIImage imageNamed: imgName];
}





@end
