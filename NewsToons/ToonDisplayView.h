//
//  ToonDisplayView.h
//  NewsToons
//
//  Created by Daniela Postigo on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "BasicToonView.h"
#import "URLShortener.h"
#import "YoutubeView.h"
#import "InformationView.h"
#import "GlossyUIView.h"
#import "Constants.h"
#import "ToonInfoCell.h"
#import "TubeView.h"


#define infoKey  @"Info"
#define relatedKey  @"Related Toons"
#define linksKey  @"Behind the Toons"
#define sharingKey @"Share"

#define tableHeaderHeight 20
#define descriptionHeight 120
#define shareHeight 120
#define rHeight 130
#define iconViewWidth 90
#define iconPadding 8

@interface ToonDisplayView : BasicToonView <UITableViewDelegate, UITableViewDataSource> {

    IBOutlet UIImageView *toonImageView;

    IBOutlet UITableView *table;
    IBOutlet UIView *shareView;
    IBOutlet UIButton *facebookButton;
    IBOutlet UIButton *twitterButton;
    IBOutlet UIButton *favoriteButton;
    IBOutlet UIButton *sendButton;
    UITableViewCell *shareCell;
    UITableViewCell *descriptionCell;
    UITableViewCell *relatedCell;
    ToonInfoCell *infoCell;
    UIScrollView *relatedScrollView;
    NSMutableArray *linkTableCells;
    NSMutableArray *sectionKeys;
    NSMutableDictionary *sectionContents;
    NSMutableArray *tableHeaders;
    NSMutableDictionary *relatedIcons;
    GlossyUIView *infoButton;
    TubeView *tubeView;
}

@property(nonatomic, retain) TubeView *tubeView;
@property(nonatomic, retain) IBOutlet UIImageView *toonImageView;
@property(nonatomic, retain) IBOutlet UITableView *table;
@property(nonatomic, retain) IBOutlet UIView *shareView;
@property(nonatomic, retain) IBOutlet UIButton *facebookButton;
@property(nonatomic, retain) IBOutlet UIButton *twitterButton;
@property(nonatomic, retain) IBOutlet UIButton *favoriteButton;
@property(nonatomic, retain) IBOutlet UIButton *sendButton;
@property(nonatomic, retain) UITableViewCell *shareCell;
@property(nonatomic, retain) UITableViewCell *descriptionCell;
@property(nonatomic, retain) UITableViewCell *relatedCell;
@property(nonatomic, retain) UIScrollView *relatedScrollView;
@property(nonatomic, retain) NSMutableArray *linkTableCells;
@property(nonatomic, retain) NSMutableArray *sectionKeys;
@property(nonatomic, retain) NSMutableDictionary *sectionContents;
@property CGFloat infoViewWidth;
@property(nonatomic, retain) UIPageControl *pageControl;
@property(nonatomic, retain) NSDictionary *relatedIcons;
@property(nonatomic, retain) ToonInfoCell *infoCell;


- (void) setToonObject: (Toon *) toon;
- (void) handleTableContent;
- (IBAction) revealDescription;
- (void) setupTableView;
- (UITableViewCell *) shareCell;
- (UITableViewCell *) descriptionCell;
- (UITableViewCell *) relatedCell;
- (UIScrollView *) relatedScrollView;
- (void) handleRelatedContent;
- (UIView *) iconView: (Toon *) toon;
- (void) loadIconImages;
- (void) removeActivityView;
- (void) handleVideoView;
- (void) handleLinks;
- (void) handleLinkCells;
- (NSMutableArray *) tableHeaders;
- (UIView *) tableHeader: (NSString *) title;
- (CGFloat) width;
- (void) setWidth: (CGFloat) w;
- (void) clearTableCells;

@end
