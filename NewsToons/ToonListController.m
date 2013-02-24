//
//  ToonListController.h
//  
//  Created by Dani Postigo on 3/29/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import <QuartzCore/QuartzCore.h>
#import "ToonListController.h"
#import "DesktopCell.h"
#import "GlassButton.h"
#import "UIView+Addons.h"
#import "Model.h"
#import "NSBundle+LoadNibView.h"
#import "NSObject+Utility.h"


@interface ToonListController ()

- (UIView *) tableFooterView;
@property ( nonatomic ) ToonLibrarySortMode sortMode;
- (void) setup;
- (void) initTable;
- (void) reloadTable;


@end

@implementation ToonListController {
    NSMutableArray * tableSource;
    UITableView * table;
    ToonLibrarySortMode sortMode;
    UIView * tableFooterView;
    UIActivityIndicatorView * activityView;
}

@synthesize sortMode;

- (void) setup {
	
}

- (id) initWithCoder: (NSCoder *) aDecoder {
    self = [super initWithCoder: aDecoder];
    if ( self ) {
        sortMode = ToonLibrarySortByDate;
        [self addSelector: @selector(reloadTable) name: initialLoadReadyKey withObject: nil];
        [self addSelector: @selector(reloadAllToons) name: toonsReadyKey withObject: nil];
    }

    return self;

}

- (void) awakeFromNib {
   [super awakeFromNib];
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);
}


- (void) dealloc {
    [tableSource release];
    table.delegate = nil, [table release];
    [super dealloc];
}

- (void) viewDidLoad {

    [self initTable];
    table.frame = self.view.frame;
}

- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

    [self initTable];
    table.frame = self.view.frame;

}



- (void) initTable {

    tableSource = [[NSMutableArray alloc] init];

    table = [[UITableView alloc] initWithFrame: self.view.frame style: UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor blackColor];
    table.separatorColor = [UIColor blackColor];
    table.tableFooterView = self.tableFooterView;
    [self.view addSubview: table];

    [self addSelector: @selector(reloadTable) name: initialLoadReadyKey withObject: nil];

}






- (void) reloadTable {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);
    self.sortMode = ToonLibrarySortByDate;
}





#pragma mark Private methods

- (UIView *) tableFooterView {
    if ( ! tableFooterView ) {

        CGFloat padding = 20;
        GlassButton * glossy;

        glossy = [[[GlassButton alloc] initWithFrame: CGRectMake(0, 0, table.width, 40)] autorelease];
        glossy.text = @"Load More Toons";
        glossy.titleLabel.font = [UIFont boldSystemFontOfSize: 11.0];
        glossy.color = [UIColor blackColor];
        glossy.layer.cornerRadius = 20.0;
        glossy.top = padding / 2;


        tableFooterView = [[[UIView alloc] init] autorelease];
        tableFooterView.width = glossy.width;
        tableFooterView.height = glossy.height + padding;

        [tableFooterView addSubview: glossy];
        [glossy addTarget: self action: @selector(loadMoreClicked:) forControlEvents: UIControlEventTouchUpInside];

    }
    return tableFooterView;
}






#pragma mark Sorting methods




- (void) reloadAllToons {

    [activityView stopAnimating];
    [activityView removeFromSuperview];
    [activityView release], activityView = nil;

    [self reloadTable];

}



- (void) setSortMode: (ToonLibrarySortMode) mode {
    sortMode = mode;
    [tableSource release];

    tableSource = [[NSMutableArray alloc] init];


    NSMutableArray * mToons = [self.model toonsSortedBy: sortMode];
    [tableSource addObjectsFromArray: mToons];
    [table reloadData];
}






#pragma mark UITableViewDelegate


- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

    UITableViewCell * cell;
    DesktopCell * cellView;
    NSString * cellId;
    Toon * toon;



    toon = [tableSource objectAtIndex: indexPath.row];
    cellId = [@"ToonList-" stringByAppendingString: toon.youtubeId];
    cell = [tableView dequeueReusableCellWithIdentifier: cellId];

    if ( cell == nil ) {
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellId] autorelease];

        cellView = [[[DesktopCell alloc] initWithFrame: CGRectMake(0, 0, 320, desktopCellHeight)] autorelease];
        //cellView = [NSBundle loadNibView: @"SlimCell"];
        cellView.toonObject = toon;
        cellView.tag = 10;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview: cellView];

    }


    cellView = (DesktopCell *) [cell.contentView viewWithTag: 10];
    BadgeView * badge = cellView.badge;
    NSString * badgeText;

    cellView.badge.hidden = NO;
    if ( sortMode == ToonLibrarySortByViewCount ) {
        badgeText = cellView.toonObject.viewCountString;
    }

    else if ( sortMode == ToonLibrarySortByRating ) {
        badgeText = cellView.toonObject.ratingString;
    }

    else if ( sortMode == ToonLibrarySortByEmailCount ) {
        badgeText = [NSString stringWithFormat: @"%d", cellView.toonObject.emailCount];
    }

    else {
        badgeText = @"";
        cellView.badge.hidden = YES;
    }

    badge.text = badgeText;
    return cell;

}


- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    return desktopCellHeight;
}


- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
    return tableSource.count;

}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {


    /*
    Toon * toon = [tableSource objectAtIndex: indexPath.row];
    UIViewController * controller = [self controllerForToon: toon];
    [self.navigationController pushViewController: controller animated: YES];
      */

}


@end