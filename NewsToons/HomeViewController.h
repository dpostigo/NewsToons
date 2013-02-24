//
//  HomeViewController.h
//  NewsToons
//
//  Created by Daniela Postigo on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaveTwitterController.h"
#import "ToonDisplayViewController.h"
#import "ToonLibrarySortMode.h"
#import "SplashView.h"

@class FaveTwitterController;

@interface HomeViewController : FaveTwitterController <UITableViewDelegate, UITableViewDataSource> {


    SplashView *splashView;


    IBOutlet UIButton *facebookButtonIB;
    IBOutlet UIButton *twitterButtonIB;
    IBOutlet UIButton *favoriteButtonIB;
    IBOutlet UIButton *sendButtonIB;

    IBOutlet UILabel *featuredToonTitle;
    IBOutlet UILabel *categoryLabel;
    IBOutlet UIWebView *webView;
    IBOutlet UIScrollView *categoriesScrollView;
    IBOutlet UIImageView *featuredImage;

    IBOutlet UITableView *table;
    NSMutableArray *tableSource;
    ToonLibrarySortMode sortMode;
    UIActivityIndicatorView *activity;
    UIView *tableFooterView;

    ToonDisplayViewController *toonDisplayController;


}

@property(nonatomic, assign) ToonLibrarySortMode sortMode;
@property(nonatomic, retain) IBOutlet UITableView *table;

@property(nonatomic, retain) NSMutableArray *tableSource;
@property(nonatomic, retain) UIActivityIndicatorView *activity;
@property(nonatomic, retain) UIView *tableFooterView;
@property(nonatomic, retain) SplashView *splashView;
@property(nonatomic, retain) ToonDisplayViewController *toonDisplayController;
- (IBAction) handleFeaturedClicked;
- (UILabel *) newLabelFromLabel: (UILabel *) label;
- (UIButton *) categoryButtonFromString: (NSString *) string;
- (void) reloadTable;
- (void) createSortingLabels;
- (void) handleSortingClicked: (id) sender;



//- (ToonLibrarySortMode) sortMode;
//- (void) setSortMode: (ToonLibrarySortMode) mode;
//- (void) handleSetup;
//- (void) getToons;

//- (void) handleFeaturedToon;
//- (void) handleFeaturedThumb;
//- (void) handleFeaturedHotspots;




@end
