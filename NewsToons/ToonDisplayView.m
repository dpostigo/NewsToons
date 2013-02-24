//
//  SplashView.m
//  NewsToons
//
//  Created by Daniela Postigo on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "Toon.h"
#import "ToonDisplayView.h"

#import "UIImage+Addons.h"
#import "UIView+Toons.h"
#import "UIView+Addons.h"
#import "UIView+Styles.h"
#import "NSString+Addons.h"
#import "GradientUIView.h"
#import "CustomHeader.h"
#import "Model.h"
#import "StarRatingView.h"
#import "GlassButton.h"
#import "TubeView.h"


#define LESS_TEXT @"less"
#define MORE_TEXT @"more"
#define viewAllKey @"View All"


@interface ToonDisplayView ()


- (UIView *) statsView;
- (UITableViewCell *) formattedCell: (NSString *) string;

@end


@implementation ToonDisplayView {
    CGFloat cellPadding;
    UIPageControl *pageControl;
    UIActivityIndicatorView *activityView;
    GlassButton *moreButton;
}


@synthesize toonImageView;
@synthesize table;

@synthesize facebookButton;
@synthesize twitterButton;
@synthesize favoriteButton;
@synthesize sendButton;

@synthesize linkTableCells;
@synthesize sectionKeys;
@synthesize sectionContents;

@synthesize tubeView;
@synthesize infoViewWidth;

@synthesize shareCell;
@synthesize descriptionCell;
@synthesize relatedCell;

@synthesize relatedScrollView;
@synthesize shareView;
@synthesize pageControl;
@synthesize relatedIcons;
@synthesize infoCell;


- (id) initWithFrame: (CGRect) frame {

    self = [super initWithFrame: frame];
    if (self) {
    }
    return self;
}


- (void) loadedFromNib {
    [super loadedFromNib];

    [self makeShareCell];
    cellPadding = 10;

    UIImageView *background = [self quickBackgroundImage];
    [self insertSubview: background atIndex: 0];

    [facebookButton rasterize];
    [twitterButton rasterize];
    [favoriteButton rasterize];
    [sendButton rasterize];

    table.delegate = self;
    table.dataSource = self;
    //table.backgroundView = [[[UIView alloc] init] autorelease];
    //table.backgroundView.backgroundColor = [UIColor clearColor];
    //table.backgroundView.opaque = NO;

    table.clipsToBounds = YES;
    table.height -= 5;

    self.table.rowHeight = 10;

    //[self.table.backgroundView rasterize];
    [self handleTableContent];
}


- (void) dealloc {

    [facebookButton release];
    [twitterButton release];
    [favoriteButton release];
    [sendButton release];

    [toonObject release];

    [linkTableCells release], linkTableCells = nil;
    [infoCell release], infoCell = nil;
    [shareCell release], shareCell = nil;
    [relatedCell release], relatedCell = nil;
    [relatedScrollView release], relatedScrollView = nil;
    [descriptionCell release], descriptionCell = nil;

    [tubeView release];
    [sectionContents release];
    [sectionKeys release];

    table.delegate = nil;
    table.dataSource = nil;
    [table release];

    [pageControl release];
    [tableHeaders release];
    [activityView release];
    [moreButton release];
    [shareView release];
    [relatedIcons release];
    //[toonImageView release];
    [super dealloc];
}



#pragma mark General

- (CGFloat) width {
    return self.frame.size.width;
}


- (void) setWidth: (CGFloat) w; {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, w, self.frame.size.height);
}


- (void) clearTableCells {
}



#pragma mark ToonObject


- (void) setToonObject: (Toon *) toon {
    if (toon != toonObject) {
        [toon retain];
        [toonObject release];
        toonObject = toon;

        [self createInfoCell];

        [self handleLinks];
        [self handleVideoView];
    }
}


- (void) handleLinks {

    if ([toonObject.moreInfoLinks count] > 0) {
        NSUInteger truncLinks = 4;
        NSMutableArray *toonLinks;
        NSUInteger length;
        NSRange range;

        toonLinks = toonObject.moreInfoLinks;
        length = toonLinks.count < truncLinks ? toonLinks.count: truncLinks;
        range = NSMakeRange(0, length);

        NSArray *links = [toonObject.moreInfoLinks subarrayWithRange: range];
        NSMutableArray *mLinks = [[[NSMutableArray alloc] init] autorelease];
        [mLinks addObjectsFromArray: links];
        if (length == truncLinks) [mLinks addObject: viewAllKey];

        [self.sectionContents setObject: mLinks forKey: linksKey];
        [self.sectionKeys addObject: linksKey];

        [self handleLinkCells];
    }
}


- (void) handleVideoView {

    if (IPHONE) {

        self.tubeView = [[TubeView alloc] initWithFrame: toonImageView.frame tubeID: toonObject.youtubeId];
        [tubeView addShadow];
        [self addSubview: tubeView];
        [tubeView load];

        [toonImageView removeFromSuperview];
        [toonImageView release];
    }

    NSLog(@"Handled video view.");

    NSLog(@"[UIDevice currentDevice].systemVersion = %@", [UIDevice currentDevice].systemVersion);
}


#pragma mark Reveal description

- (IBAction) revealDescription {
    NSArray *indexPaths;
    NSMutableArray *shareArray;

    shareArray = [self.sectionContents objectForKey: sharingKey];
    indexPaths = [NSArray arrayWithObject: [NSIndexPath indexPathForRow: 1 inSection: 0]];

    [self.table beginUpdates];

    if ([shareArray count] == 1) {
        moreButton.text = LESS_TEXT;
        [shareArray addObject: @"Info"];
        [self.table insertRowsAtIndexPaths: indexPaths withRowAnimation: UITableViewRowAnimationFade];
    }
    else if ([shareArray count] == 2) {
        moreButton.text = MORE_TEXT;
        [shareArray removeLastObject];
        [self.table deleteRowsAtIndexPaths: indexPaths withRowAnimation: UITableViewRowAnimationFade];
    }

    [self.table endUpdates];
}


- (void) handleTableContent {
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSMutableDictionary *contents = [[NSMutableDictionary alloc] init];

    [keys addObject: sharingKey];
    [contents setObject: [NSMutableArray arrayWithObject: @"Share"] forKey: sharingKey];

    //[keys addObject: relatedKey];
    //[contents setObject: [NSArray arrayWithObjects: @"Related", nil] forKey: relatedKey];

    [self setSectionKeys: keys];
    [self setSectionContents: contents];

    [keys release], keys = nil;
    [contents release], contents = nil;
}



#pragma mark -
#pragma mark LinkCells


- (void) handleLinkCells {
    NSLog(@"Started linkCells.");

    NSMutableArray *links = [self.sectionContents objectForKey: linksKey];
    linkTableCells = [[NSMutableArray alloc] init];

    CGFloat tableWidth = self.table.frame.size.width;
    for (NSString *string in links) {

        NSString *identifier = [NSString stringWithFormat: @"Cell%@", string];
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: identifier] autorelease];

        cell.backgroundView = [[[UIView alloc] init] autorelease];
        cell.backgroundView.backgroundColor = [UIColor clearColor];

        CGRect bgRect = CGRectMake(0, 0, tableWidth, linkRowHeight);
        GradientUIView *styledBg = [[[GradientUIView alloc] initWithFrame: bgRect] autorelease];
        styledBg.opaque = NO;
        styledBg.separatorColor = [UIColor blackColor];
        styledBg.lightSeparatorColor = [UIColor colorWithWhite: 0.35 alpha: 1.0];

        [self formatTextLabel: cell.textLabel string: string];

        if ([string isEqualToString: viewAllKey]) {
            cell.textLabel.text = viewAllKey;
        }

        else {
            cell.imageView.image = [self.model getPressIcon: [string stripURLString]];
            cell.imageView.left = cell.imageView.left + 10;
            cell.detailTextLabel.text = string;
        }

        //[cell.backgroundView addSubview: styledBg];
        cell.contentView.backgroundColor = [UIColor clearColor];

        cell.detailTextLabel.font = [cell.textLabel.font fontWithSize: 10.0];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"white-disclosure-indicator.png"]] autorelease];

        [linkTableCells addObject: cell];
    }
}



#pragma mark TableHeaders


- (NSString *) tableView: (UITableView *) tableView titleForHeaderInSection: (NSInteger) section {
    return [self.sectionKeys objectAtIndex: (NSUInteger) section];
}


- (NSMutableArray *) tableHeaders {
    if (!tableHeaders) {
        tableHeaders = [[NSMutableArray alloc] init];

        for (NSString *key in sectionKeys) {
            key = [key uppercaseString];
            UIView *header = [self tableHeader: key];
            [tableHeaders addObject: header];
            //[header release];
        }
    }
    return tableHeaders;
}


- (UIView *) tableView: (UITableView *) tableView viewForHeaderInSection: (NSInteger) section {
    return [self.tableHeaders objectAtIndex: section];
}


- (UIView *) tableHeader: (NSString *) title {

    UILabel *label;
    CustomHeader *headerView;
    CGRect rect;

    label = [[[UILabel alloc] initWithFrame: CGRectMake(10, 3, 320, 14)] autorelease];
    label.text = title;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize: 11.0];
    [label rasterize];

    rect = CGRectMake(0, 0, self.table.bounds.size.width, tableHeaderHeight);
    headerView = [[[CustomHeader alloc] initWithFrame: rect] autorelease];
    headerView.lightColor = [UIColor colorWithWhite: 0.8 alpha: 1.0];
    headerView.darkColor = [UIColor colorWithWhite: 1.0 alpha: 1.0];
    headerView.clipsToBounds = NO;
    [headerView addShadow];
    [headerView addSubview: label];
    //[headerView rasterize];

    UIView *container = [[[UIView alloc] initWithFrame: headerView.frame] autorelease];
    [container addSubview: headerView];
    [container rasterize];
    return container;
}


- (CGFloat) tableView: (UITableView *) tableView heightForHeaderInSection: (NSInteger) section {
    return tableHeaderHeight;
}


- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {

    NSString *sectionKey = [sectionKeys objectAtIndex: (NSUInteger) indexPath.section];
    CGFloat value;

    if ([sectionKey isEqualToString: sharingKey]) {
        if (indexPath.row == 0) value = shareView.height;
        else {

            value = self.infoCell.contentView.height;
        }
    }

    else if ([sectionKey isEqualToString: relatedKey])
        value = rHeight;

    else
        value = linkRowHeight;

    return value;
}



#pragma mark TableView

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView {
    return [self.sectionKeys count];
}


- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
    NSArray *contents = [[self sectionContents] objectForKey: [self.sectionKeys objectAtIndex: (NSUInteger) section]];
    return [contents count];
}


- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

    NSUInteger row = (NSUInteger) indexPath.row;
    NSString *sectionKey = [self.sectionKeys objectAtIndex: (NSUInteger) indexPath.section];
    NSMutableArray *scontents = [self.sectionContents objectForKey: sectionKey];
    NSString *string = [scontents objectAtIndex: row];
    NSString *cellId = [@"Cell" stringByAppendingString: string];
    UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier: cellId];

    if (cell == nil) {
        if ([sectionKey isEqualToString: linksKey]) {
            cell = [linkTableCells objectAtIndex: row];
        }

        else {

            if ([sectionKey isEqualToString: sharingKey]) {
                if (indexPath.row == 0) cell = shareCell;
                else cell = self.infoCell;
            }

            else if ([sectionKey isEqualToString: infoKey]) {
                cell = self.descriptionCell;
            }

            else if ([sectionKey isEqualToString: relatedKey]) {
                cell = self.relatedCell;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }

    return cell;
}


- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

    NSString *sectionKey = [self.sectionKeys objectAtIndex: indexPath.section];

    if ([sectionKey isEqualToString: linksKey]) {

        NSMutableArray *scontents = [self.sectionContents objectForKey: sectionKey];
        NSString *string = [scontents objectAtIndex: indexPath.row];

        if ([string isEqualToString: viewAllKey]) {
            [[NSNotificationCenter defaultCenter] postNotificationName: @"ViewAllLinks" object: nil userInfo: nil];
        }

        else {
            [[NSNotificationCenter defaultCenter] postNotificationName: @"ExternalLink" object: nil userInfo: [NSDictionary dictionaryWithObject: string forKey: @"String"]];
        }

        [self.table deselectRowAtIndexPath: indexPath animated: YES];
    }
}


- (void) makeShareCell {
    shareCell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: @"sharecell"];
    shareCell.height = shareHeight;
    shareCell.backgroundView = [[[UIView alloc] initWithFrame: shareView.frame] autorelease];
    [shareCell.contentView addSubview: shareView];
    [shareView sizeToFit];
    [shareCell.contentView sizeToFit];

    UIView *accessoryView;
    moreButton = [[GlassButton alloc] initWithFrame: CGRectMake(0, 0, 80, 30)];
    moreButton.color = [UIColor blackColor];
    moreButton.text = MORE_TEXT;
    [moreButton addTarget: self action: @selector(revealDescription) forControlEvents: UIControlEventTouchUpInside];

    shareCell.accessoryView = [[[UIView alloc] init] autorelease];
    accessoryView = shareCell.accessoryView;
    accessoryView.width = moreButton.width;
    accessoryView.height = moreButton.height;
    [accessoryView addSubview: moreButton];
}


- (void) createInfoCell {

    self.infoCell = [[[ToonInfoCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: @"sharecell" toon: toonObject] autorelease];
}


/*
- (UITableViewCell *) infoCell {

    if (infoCell == nil)
    return infoCell;


    if (!infoCell) {

        infoCell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: @"sharecell"];
        infoCell.height = shareHeight;
        infoCell.backgroundView = [[[UIView alloc] initWithFrame: shareView.frame] autorelease];
        [self formatTextLabel: infoCell.textLabel string: toonObject.descriptionText];
        infoCell.textLabel.text = toonObject.descriptionText;
        infoCell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        infoCell.textLabel.numberOfLines = 0;
        infoCell.textLabel.font = [UIFont systemFontOfSize: 12.0];

        CGSize size = [toonObject.descriptionText sizeWithFont: infoCell.textLabel.font constrainedToSize: CGSizeMake(self.table.width, 20000.0f) lineBreakMode: UILineBreakModeWordWrap];
        CGFloat infoHeight = size.height + 60;
        infoCell.textLabel.width = self.table.width - 10;
        [infoCell.textLabel sizeToFit];
        infoCell.height = infoHeight;
        infoCell.backgroundView = [[[UIView alloc] initWithFrame: CGRectZero] autorelease];

        UIView *statsView = self.statsView;
        [infoCell.contentView addSubview: self.statsView];
        [infoCell.contentView addSubview: infoCell.textLabel];

        infoCell.textLabel.top = statsView.height + 25;
    }

    return infoCell;
}

*/

- (UIView *) statsView {

    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);
    CGFloat padding = 10;
    UIView *statsView;
    statsView = [[[UIView alloc] init] autorelease];

    StarRatingView *ratingView;
    ratingView = [[[StarRatingView alloc] init] autorelease];
    ratingView.rating = (float) toonObject.rating;
    [statsView addSubview: ratingView];
    ratingView.left = 12;

    UILabel *viewsLabel = [[[UILabel alloc] initWithFrame: CGRectMake(0, 0, 10, 10)] autorelease];
    viewsLabel.textAlignment = UITextAlignmentLeft;
    viewsLabel.text = [NSString stringWithFormat: @"%@ views", toonObject.viewCountString];
    viewsLabel.textColor = [UIColor whiteColor];
    viewsLabel.backgroundColor = [UIColor clearColor];
    viewsLabel.font = [UIFont boldSystemFontOfSize: 11.0];
    [viewsLabel sizeToFit];
    [statsView addSubview: viewsLabel];

    viewsLabel.left = ratingView.left + ratingView.width + padding;
    viewsLabel.centerY = ratingView.height / 2;

    UIImage *image = [[UIImage newImageFromResource: @"thumbsup-icon.png"] autorelease];
    UIImageView *likesIcon = [[[UIImageView alloc] initWithImage: image] autorelease];
    UILabel *likesLabel = [self labelFromLabel: viewsLabel];
    likesLabel.text = [NSString stringWithFormat: @"%d", toonObject.likeCount];
    [likesLabel sizeToFit];

    likesIcon.left = viewsLabel.left + viewsLabel.width + padding;
    likesLabel.left = likesIcon.left + likesIcon.width + padding / 2;
    likesIcon.top = -2;
    statsView.width = table.width;
    statsView.height = ratingView.height + 20;

    [statsView addSubview: likesIcon];
    [statsView addSubview: likesLabel];

    if (toonObject.emailCount > 0) {

        UIImageView *emailIcon = [[[UIImageView alloc] initWithImage: [[UIImage newImageFromResource: @"email_count_icon.png"] autorelease]] autorelease];
        UILabel *emailLabel = [self labelFromLabel: likesLabel];
        emailLabel.text = [NSString stringWithFormat: @"%d", toonObject.emailCount];
        [emailLabel sizeToFit];

        emailIcon.left = likesLabel.left + likesLabel.width + padding * 1.5;
        emailLabel.left = emailIcon.left + emailIcon.width + padding / 2;
        emailIcon.centerY = emailLabel.centerY;

        [statsView addSubview: emailIcon];
        [statsView addSubview: emailLabel];
    }

    return statsView;
}


- (UITableViewCell *) descriptionCell {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);
    if (!descriptionCell) {

        UIView *container;
        UILabel *viewLabel;
        NSString *viewCount;
        InformationView *descriptionView;

        descriptionCell = [self formattedCell: @"Description"];
        [descriptionCell.textLabel removeFromSuperview];
        [descriptionCell.detailTextLabel removeFromSuperview];

        container = [[UIView alloc] init];
        [descriptionCell.contentView addSubview: container];

        descriptionView = [[InformationView alloc] initWithFrame: CGRectMake(0, 0, 320, descriptionHeight)];
        descriptionView.titleVisible = NO;
        descriptionView.backgroundColor = [UIColor clearColor];
        [descriptionView handleString: toonObject.descriptionText];
        [container addSubview: descriptionView];

        viewCount = [NSString stringWithFormat: @"Views: %d", toonObject.viewCount];
        viewLabel = descriptionCell.textLabel;
        viewLabel.text = viewCount;
        viewLabel.font = [UIFont boldSystemFontOfSize: 11.0];
        viewLabel.textColor = [UIColor whiteColor];
        viewLabel.textAlignment = UITextAlignmentLeft;
        [container addSubview: viewLabel];

        NSString *likeCount;
        UIView *likesView;
        UILabel *label;

        likeCount = [NSString stringWithFormat: @"Likes: %d", toonObject.likeCount];

        likesView = [[[UIView alloc] initWithFrame: shareCell.textLabel.frame] autorelease];
        label = [self labelFromLabel: shareCell.textLabel];
        label.text = likeCount;
        [likesView addSubview: label];
        [likesView sizeToFit];
        [container addSubview: likesView];

        container.width = descriptionView.width;
        descriptionView.top = viewLabel.height;

        NSLog(@"descriptionView.left = %f", descriptionView.left);
        descriptionView.left = 15;
        [descriptionView release];
    }

    return descriptionCell;
}


- (UITableViewCell *) relatedCell {

    if (!toonObject.relatedToons) [self.model getRelatedToons: toonObject];

    if (!relatedCell) {
        int length;
        CGFloat rWidth;

        length = [toonObject.relatedToons count];
        rWidth = length * (iconViewWidth + iconPadding) + iconViewWidth + 10;

        relatedCell = [self formattedCell: @"Related"];
        relatedCell.backgroundView = nil;

        pageControl = [[UIPageControl alloc] init];
        pageControl.numberOfPages = (NSInteger) floor(length / 3);

        [relatedCell.contentView addSubview: self.relatedScrollView];
        [relatedCell.contentView addSubview: pageControl];

        relatedScrollView.width = 3 * (iconViewWidth + iconPadding);
        relatedScrollView.contentSize = CGSizeMake(rWidth, relatedScrollView.height);
        relatedScrollView.centerX = relatedCell.centerX + iconPadding;

        pageControl.top = relatedScrollView.height - (iconPadding* 2);
        pageControl.centerX = relatedCell.centerX;

        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
        activityView.frame = relatedCell.frame;
        [relatedCell.contentView addSubview: activityView];
        relatedScrollView.alpha = 0;
        [activityView startAnimating];

        [self performSelectorOnMainThread: @selector(loadIconImages) withObject: nil waitUntilDone: NO];
    }
    return relatedCell;
}


- (UITableViewCell *) formattedCell: (NSString *) string {

    NSString *identifier;
    UITableViewCell *cell;

    identifier = [@"Cell" stringByAppendingString: string];
    cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: identifier] autorelease];

    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = nil;
    return cell;
}


- (UIScrollView *) relatedScrollView; {
    if (!relatedScrollView) {
        relatedScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 0, self.table.width, rHeight)];
        relatedScrollView.scrollEnabled = YES;
        relatedScrollView.pagingEnabled = YES;
        relatedScrollView.showsHorizontalScrollIndicator = NO;

        [self performSelectorOnMainThread: @selector(handleRelatedContent) withObject: nil waitUntilDone: NO];
    }
    return relatedScrollView;
}


- (void) handleRelatedContent {
    int i = 0;
    relatedIcons = [[NSMutableDictionary alloc] init];

    int length = [toonObject.relatedToons count];
    Toon *toon;
    UIView *toonView;
    for (i = 0; i < length; i++) {
        toon = [toonObject.relatedToons objectAtIndex: i];
        toonView = [self iconView: toon];
        toonView.frame = CGRectMake(i * (toonView.frame.size.width + iconPadding), iconPadding, toonView.frame.size.width, toonView.frame.size.height);
        [self.relatedScrollView addSubview: toonView];
        [toonView release];
    }
}


- (UIView *) iconView: (Toon *) toon {

    UIView *contentView;
    contentView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, iconViewWidth, iconViewWidth)];

    /*
    LoadingUIView * activityView;
    activityView =  [[LoadingUIView alloc] initWithFrame: CGRectMake(0, 0, iconViewWidth, iconViewWidth)];
    activityView.isSubview = YES;
    [activityView beginActivity];
    */


    UIImageView *imageView;
    imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, iconViewWidth, iconViewWidth)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.layer.borderColor = [UIColor blackColor].CGColor;
    imageView.layer.borderWidth = 1.0;
    [imageView addShadow];

    [contentView addSubview: imageView];
    //[contentView rasterize];



    NSString *key = [[toon.youtubeThumbnail absoluteString] copy];
    NSMutableArray *views = [[NSMutableArray alloc] init];
    [views addObject: imageView];
    [relatedIcons setObject: views forKey: key];

    [imageView release];
    [key release];
    [views release];

    return contentView;
}


- (void) loadIconImages {

    NSArray *allKeys = [relatedIcons allKeys];

    for (int i = 0; i < [allKeys count]; i++) {
        NSString *urlString;
        NSMutableArray *views;
        UIImageView *imageView;

        urlString = [allKeys objectAtIndex: i];
        views = [relatedIcons objectForKey: urlString];
        imageView = [views objectAtIndex: 0];

        UIImage *image;
        image = [self.model loadOptimizedImageFromString: urlString height: imageView.height * 1.7];
        image = [self.model cropImage: image toWidth: image.size.height];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = image;
        //[imageView rasterize];

        //[activityView stopAnimating];
        //[views release];
    }

    [activityView stopAnimating];

    //[relatedScrollView removeFromSuperview];
    //relatedScrollView.alpha = 1;
    [UIView beginAnimations: @"activity" context: nil];
    [UIView setAnimationDuration: 1.0];
    [UIView setAnimationDidStopSelector: @selector(removeActivityView)];
    //[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView: relatedCell.contentView cache: YES];
    relatedScrollView.alpha = 1;
    //[relatedCell.contentView addSubview: relatedScrollView];
    [UIView commitAnimations];

    [relatedIcons release];
}


- (void) removeActivityView {
    [activityView removeFromSuperview];
}



@end
