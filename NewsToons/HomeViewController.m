//
//  FirstViewController.m
//  NewsToons
//
//  Created by Daniela Postigo on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "HomeViewController.h"
#import "DesktopCell.h"
#import "Model.h"
#import "GlassButton.h"
#import "NSObject+Utility.h"
#import "Appirater.h"
#import "CheckFeedUpdates.h"
#import "ParseToons.h"
#import "ParseBestToons.h"
#import "ToonTableCell.h"
#import "SVPullToRefresh.h"
#import "UpdateCloud.h"


@implementation HomeViewController {
    BOOL reloading;
    BOOL shouldUpdateEmailedToons;
    UITableViewCell *lastCell;
    GlassButton *loadMoreButton;
}


@synthesize sortMode;
@synthesize tableSource;

@synthesize activity;
@synthesize tableFooterView;
@synthesize table;
@synthesize splashView;
@synthesize toonDisplayController;

#define bestOfKey @"Best Of"
#define viewedKey @"Most Viewed"
#define ratedKey @"Top Rated"
#define emailedKey @"Most Emailed"



#pragma mark View lifecycle




- (void) dealloc {

    [self removeSelector: toonsReadyKey];
    [loadMoreButton release];
    [toonDisplayController release];
    [tableSource release];
    table.delegate = nil, [table release];
    [tableFooterView release];

    [_queue release];
    [activity release];
    [splashView release];
    [super dealloc];
}


- (void) awakeFromNib {
    [super awakeFromNib];
    self.title = @"Home";
    sortMode = ToonLibrarySortByDate;

    _queue.maxConcurrentOperationCount = 1;

    self.tableSource = [[[NSMutableArray alloc] init] autorelease];

    NSLog(@"%s", __PRETTY_FUNCTION__);

    self.activity = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite] autorelease];
    activity.hidesWhenStopped = YES;

    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = YES;

    self.favoriteButton = favoriteButtonIB;
    self.twitterButton = twitterButtonIB;
    self.facebookButton = facebookButtonIB;
    self.sendButton = sendButtonIB;

    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = tableFooterView;
    [self createTableFooterView];

    [self createSortingLabels];

    table.pullToRefreshView.textColor = [UIColor whiteColor];
    table.pullToRefreshView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;

    [table addPullToRefreshWithActionHandler: ^{
        [self performSelector: @selector(tableViewDidTriggerRefresh) withObject: nil afterDelay: 0];
    }];

    NSLog(@"[_model.toonLibrary count] = %u", [_model.toonLibrary count]);

    if ([_model.toonLibrary count] == 0) {
        [self showSplashView];
    }
    else {
        [self reloadTable];
    }
    [table.pullToRefreshView triggerRefresh];

    activity.centerX = self.view.width / 2;
    activity.centerY = table.height / 2;
    //[self.view addSubview: activity];
    //[activity startAnimating];

    //table.alpha = 0;
    [UIView animateWithDuration: 0.5 delay: 0 options: 0 animations: ^{
    }
                     completion: ^(BOOL finished) {
                         [activity stopAnimating];
                         [UIView beginAnimations: nil context: nil];
                         [UIView setAnimationDuration: 0.5];
                         [UIView setAnimationDelegate: self];
                         [UIView setAnimationDelay: 2.0];
                         table.alpha = 1;
                         [UIView commitAnimations];
                     }];
}


- (void) viewDidLoad {
    [super viewDidLoad];
}


- (void) viewWillAppear: (BOOL) animated {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden: YES animated: YES];
}


- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];
    [Appirater appLaunched: YES];

    if (shouldUpdateEmailedToons) {
        [self performSelector: @selector(reloadTable) withObject: nil afterDelay: 1.0];
    }
}


- (void) resetViewController {
    [super resetViewController];

    self.sortMode = ToonLibrarySortByDate;
    [self reloadTable];
}



#pragma mark Data loading methods



- (void) reloadTable {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self hideSplashView];
    [table.pullToRefreshView stopAnimating];

    [self prepareDataSource];

    if (sortMode == ToonLibrarySortByDate) {
        table.tableFooterView = self.tableFooterView;
    } else table.tableFooterView = [[[UIView alloc] init] autorelease];

    [table reloadData];
}


- (void) prepareDataSource {

    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (sortMode == ToonLibrarySortByDate) {

        //NSLog(@"SORT BY DATING");
        //NSLog(@"_model.feedDate = %@", _model.feedDate);
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"dateObject >= %@", _model.feedDate];

        self.tableSource = [[[NSMutableArray alloc] initWithArray: [self.model.toonLibrary filteredArrayUsingPredicate: predicate]] autorelease];
        if ([tableSource count] > 0) self.toonObject = [tableSource objectAtIndex: 0];
    } else {

        self.tableSource = [[[NSMutableArray alloc] initWithArray: [_model toonsSortedBy: sortMode]] autorelease];
        if (tableSource.count > 10) [tableSource removeObjectsInRange: NSMakeRange(10, [tableSource count] - 10)];

        if (sortMode == ToonLibrarySortByEmailCount) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat: @"emailCount == 0"];
            NSArray *filtered = [tableSource filteredArrayUsingPredicate: predicate];
            [tableSource removeObjectsInArray: filtered];
        }
    }

    if (sortMode != ToonLibrarySortByEmailCount) {
        if ([tableSource containsObject: self.toonObject]) [tableSource removeObject: self.toonObject];
    }

    [self checkToons];
}


- (void) checkToons {

    NSLog(@"%s", __PRETTY_FUNCTION__);

    NSString *previousTitle = self.toonObject.title;
    NSDate *previousDate = self.toonObject.dateObject;
    NSString *previousDateString = self.toonObject.date;
    for (Toon *toon in tableSource) {

        NSInteger diffDays = [self compareDate: toon.dateObject withDate: previousDate];
        if (diffDays > 7) {
            NSLog(@"%@ vs %@, difference in days = %i, %@ vs %@", previousTitle, toon.title, diffDays, previousDateString, toon.date);
        }
        previousDate = toon.dateObject;
        previousTitle = toon.title;
        previousDateString = toon.date;

        if ([toon.title isEqualToString: @"Tradition"]) {
            NSLog(@"Where is the ghost Toon, Tradition");
        }
    }
}


- (NSInteger) compareDate: (NSDate *) dateA withDate: (NSDate *) dateB {

    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar] autorelease];
    NSDateComponents *components = [calendar components: NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                               fromDate: dateA
                                                 toDate: dateB
                                                options: 0];

    return components.day;
}


- (void) oldReloadData {
    NSLog(@"%@ - %s", @"HomeViewController", sel_getName(_cmd));
    [table.pullToRefreshView stopAnimating];

    self.tableSource = [[[NSMutableArray alloc] init] autorelease];
    [tableSource addObjectsFromArray: [_model toonsSortedBy: sortMode]];

    if ([tableSource count] > 0) {

        if (sortMode == ToonLibrarySortByDate) {
            //table.tableFooterView = self.tableFooterView;

            self.tableSource = [[[NSMutableArray alloc] init] autorelease];

            NSArray *array = [self.model.toonLibrary filteredArrayUsingPredicate: [NSPredicate predicateWithFormat: @"dateObject >= %@", self.model.feedDate]];
            [self.tableSource addObjectsFromArray: array];

            if ([tableSource count] > 0) {
                self.toonObject = [tableSource objectAtIndex: 0];
            }
        } else {
            //table.tableFooterView = [[[UIView alloc] init] autorelease];
            if (tableSource.count > 10) {
                [tableSource removeObjectsInRange: NSMakeRange(10, [tableSource count] - 10)];
            }
        }

        if ([tableSource containsObject: self.toonObject]) [tableSource removeObject: self.toonObject];
        [table reloadData];
    }
}






#pragma mark UI Response functions



- (void) handleSortingClicked: (id) sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    [self.model setYoutubeValues];
    UIButton *button = (UIButton *) sender;
    NSString *labelText = button.titleLabel.text;

    if ([labelText isEqualToString: bestOfKey]) {
        self.sortMode = ToonLibrarySortByBest;
        NSLog(@"SORTING BY BEST");
    } else if ([labelText isEqualToString: viewedKey]) {
        self.sortMode = ToonLibrarySortByViewCount;
    } else if ([labelText isEqualToString: emailedKey]) {
        self.sortMode = ToonLibrarySortByEmailCount;
    } else
        self.sortMode = ToonLibrarySortByDate;

    [self reloadTable];

    [table scrollRectToVisible: CGRectMake(0, 0, 1, 1) animated: YES];
}


- (void) handleLoadMoreClicked: (id) sender {

    loadMoreButton.userInteractionEnabled = NO;

    if ([activity superview] != table.tableFooterView) [table.tableFooterView addSubview: activity];
    activity.right = loadMoreButton.width - 30;
    activity.centerY = table.tableFooterView.height / 2;
    [activity startAnimating];

    self.model.isLoadingMore = YES;

    ParseToons *operation = [[[ParseToons alloc] init] autorelease];
    operation.delegate = self;
    [_queue addOperation: operation];
}




#pragma mark UI Creation functions -



- (void) showSplashView {

    self.splashView = [[[SplashView alloc] initWithFrame: CGRectMake(0, 0, 320, 480)] autorelease];
    [self.view addSubview: splashView];
}


- (void) hideSplashView {
    if ([splashView superview] != nil) {

        [splashView fadeOut];
    }
}


- (void) createTableFooterView {

    CGFloat padding = 20;

    loadMoreButton = [[[GlassButton alloc] initWithFrame: CGRectMake(0, 0, table.width, 40)] autorelease];
    loadMoreButton.text = @"Load More Toons";
    loadMoreButton.titleLabel.font = [UIFont boldSystemFontOfSize: 11.0];
    loadMoreButton.color = [UIColor blackColor];
    loadMoreButton.layer.cornerRadius = 20.0;
    loadMoreButton.top = padding / 2;

    self.tableFooterView = [[[UIView alloc] init] autorelease];
    tableFooterView.width = loadMoreButton.width;
    tableFooterView.height = loadMoreButton.height + padding;

    [tableFooterView addSubview: loadMoreButton];
    [loadMoreButton addTarget: self action: @selector(handleLoadMoreClicked:) forControlEvents: UIControlEventTouchUpInside];
}


- (void) createSortingLabels {

    CGFloat padding = 30;
    CGFloat prevX = padding / 2;
    int count = 0;
    NSMutableArray *cStrings = [NSMutableArray array];

    [cStrings addObject: bestOfKey];
    [cStrings addObject: viewedKey];
    [cStrings addObject: emailedKey];
    //[cStrings addObject: ratedKey];

    for (NSString *string in cStrings) {
        UIButton *button = [self categoryButtonFromString: string];
        button.tag = count;
        button.frame = CGRectMake(prevX, button.top, button.width, button.height);

        [categoriesScrollView addSubview: button];
        prevX = prevX + button.width + padding;
        count++;
    }

    categoriesScrollView.contentSize = CGSizeMake(prevX, categoriesScrollView.height);
}


- (UIButton *) categoryButtonFromString: (NSString *) string {

    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    button.frame = CGRectMake(20, 12, 100, 30);
    button.backgroundColor = [UIColor clearColor];

    UILabel *label = [[self newLabelFromLabel: categoryLabel] autorelease];
    label.textColor = [UIColor whiteColor];
    label.contentMode = UIViewContentModeTop;
    label.textAlignment = UITextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    label.text = string;
    [label sizeToFit];
    [button addSubview: label];

    button.titleLabel.text = string;
    button.titleLabel.hidden = YES;
    button.frame = CGRectMake(button.left, button.top, label.frame.size.width, button.height);
    button.showsTouchWhenHighlighted = YES;

    [button addTarget: self action: @selector(handleSortingClicked:) forControlEvents: UIControlEventTouchUpInside];

    return button;
}


- (UILabel *) newLabelFromLabel: (UILabel *) label {
    UILabel *newLabel = [[UILabel alloc] initWithFrame: label.frame];
    newLabel.backgroundColor = label.backgroundColor;
    newLabel.textColor = label.textColor;
    newLabel.textAlignment = label.textAlignment;
    newLabel.text = label.text;
    newLabel.font = label.font;
    return newLabel;
}






#pragma mark Featured Methods


- (IBAction) handleFeaturedClicked {
    Toon *toon = self.toonObject;

    [self setControllerForToon: toon];
    [self.navigationController pushViewController: toonDisplayController animated: YES];
}


- (void) setToonObject: (Toon *) aToon {
    if (aToon != toonObject) {
        toonObject = aToon;

        UIImage *featuredThumb = [_model loadOptimizedImageFromString: [toonObject.youtubeThumbnail absoluteString] width: 300];
        featuredImage.image = featuredThumb;
        featuredImage.clipsToBounds = YES;
        featuredImage.layer.cornerRadius = 8.0;
        featuredImage.layer.borderColor = [UIColor blackColor].CGColor;
        featuredImage.layer.borderWidth = 1.0;
        featuredToonTitle.text = toonObject.title;
        [self updateFavoriteIcon];
    }
}





#pragma mark Operation Response functions -





- (void) toonsDidLoad: (NSMutableArray *) newToons {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);

    for (Toon *toon in newToons) {
        if ([toon.title isEqualToString: @"Tradition"]) {
            NSLog(@"toon.title = %@", toon.title);
            NSLog(@"toon.date = %@", toon.date);
            NSLog(@"toon.dateObject = %@", toon.dateObject);
        }
    }

    loadMoreButton.userInteractionEnabled = YES;
    [activity stopAnimating];

    [self reloadTable];
}


- (void) bestToonsDidLoad: (NSMutableArray *) bestToons {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);
}


- (void) emailedToonsDidLoad: (NSMutableArray *) newToons {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);
}


- (void) emailedToonsDidUpdate {
}



#pragma mark UITableViewDelegate




- (void) tableViewDidTriggerRefresh {

    NSOperation *operation1 = [[[CheckFeedUpdates alloc] init] autorelease];
    NSOperation *operation2;
    if ([_model.toonLibrary count] == 0) {
        operation2 = [[[ParseToons alloc] init] autorelease];
    } else {
        operation2 = [[[ParseToons alloc] initWithFeedURL: [NSURL URLWithString: TOON_FEED_URL]] autorelease];
    }
    NSOperation *operation3 = [[[ParseBestToons alloc] init] autorelease];

    [operation3 addDependency: operation2];
    [operation2 addDependency: operation1];

    [_queue addOperation: operation1];
    [_queue addOperation: operation2];
    [_queue addOperation: operation3];
}


- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

    Toon *toon = [tableSource objectAtIndex: (NSUInteger) indexPath.row];
    NSString *identifier = [NSString stringWithFormat: @"Cell%@", toon.nid];
    ToonTableCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];

    if (cell == nil) {
        cell = [[[ToonTableCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: identifier] autorelease];
        cell.toonObject = toon;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    [self formatCell: cell];

    return cell;
}


- (void) formatCell: (ToonTableCell *) cell {

    BadgeView *badge = cell.cellView.badge;
    NSString *badgeText;

    badge.hidden = NO;
    if (sortMode == ToonLibrarySortByViewCount) badgeText = cell.cellView.toonObject.viewCountString;
    else if (sortMode == ToonLibrarySortByRating) badgeText = cell.cellView.toonObject.ratingString;
    else if (sortMode == ToonLibrarySortByEmailCount) badgeText = [NSString stringWithFormat: @"%d", cell.cellView.toonObject.emailCount];

    else {
        badgeText = @"";
        badge.hidden = YES;
    }

    badge.text = badgeText;
}


- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    return desktopCellHeight;
}


- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
    return tableSource.count;
}


- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    Toon *toon = [tableSource objectAtIndex: (NSUInteger) indexPath.row];

    [self setControllerForToon: toon];
    [self.navigationController pushViewController: toonDisplayController animated: YES];
}


- (void) setControllerForToon: (Toon *) toon {

    if (toon != toonDisplayController.toonObject) {
        self.toonDisplayController = [[[ToonDisplayViewController alloc] initWithNibName: @"ToonDisplayView" bundle: nil] autorelease];
        toonDisplayController.toonObject = toon;
    }
}


- (void) toonDidUpdate: (Toon *) aToon {

    if ([tableSource containsObject: aToon]) {
        NSLog(@"contains toons");
        shouldUpdateEmailedToons = YES;
    }

    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (aToon == toonObject) {
        [self updateFavoriteIcon];
    }
}


- (void) shouldSaveEmailedToons: (Toon *) aToon {

    NSOperation *operation = [[[UpdateCloud alloc] initWithToon: aToon] autorelease];
    [_queue addOperation: operation];
}

@end
