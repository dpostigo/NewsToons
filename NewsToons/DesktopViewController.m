//
//  FirstViewController.m
//  NewsToons
//
//  Created by Daniela Postigo on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DesktopViewController.h"
#import "ToonDisplayViewController.h"
#import "Model.h"

#define CELL_HEIGHT 85

@implementation DesktopViewController {

    UITableView *table;
    NSMutableArray *tableSource;
    int loadCount;
    ToonDisplayViewController *controller;
}

@synthesize toonDisplayController;


- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
    }

    return self;
}




#pragma mark View lifecycle


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void) viewDidUnload {
    [super viewDidUnload];
}


- (void) dealloc {
    [tableSource release];
    table.delegate = nil;
    [table release];
    [backgroundImage release];
    [noFavorites release];
    if (controller) [controller release];
    [super dealloc];
}


- (void) awakeFromNib {
    [super awakeFromNib];
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);
}


- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden: YES animated: YES];
}


- (void) viewDidLoad {
    [super viewDidLoad];
    self.title = @"My Toons";
    self.view.backgroundColor = [UIColor blackColor];

    //[self handleDisplaySetup];

    tableSource = [[NSMutableArray alloc] init];

    table = [[UITableView alloc] init];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor clearColor];
    table.separatorColor = [UIColor blackColor];
    table.frame = scrollView.frame;
    [self.view addSubview: table];
    [self.view addSubview: noFavorites];

    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);

    [self updateFavorites];

    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(updateFavorites) name: favoritesUpdatedKey object: nil];

    [scrollView removeFromSuperview];
    [scrollView release];
}


- (void) updateFavorites {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);

    [tableSource release];
    tableSource = [[NSMutableArray alloc] init];

    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"isFavorite == YES"];
    NSMutableArray *favorites = [[[NSMutableArray alloc] initWithArray: [_model.toonLibrary filteredArrayUsingPredicate: predicate]] autorelease];

    [tableSource addObjectsFromArray: favorites];
    [table reloadData];

    if (tableSource.count > 0) {
        if ([noFavorites superview])
            [noFavorites removeFromSuperview];
    }
    else [self.view addSubview: noFavorites];
}


- (void) handleDisplaySetup {

    if (IPAD) {
        backgroundImage.image = [UIImage imageNamed: @"ipad-desktop.png"];

        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 768, 1024);

        CGFloat width = 680;
        CGFloat height = 900;
        scrollView.frame = CGRectMake(768 / 2 - width / 2, 130, width, height);
        noFavorites.frame = CGRectMake(
                width / 2 - (noFavorites.frame.size.width / 2),
                noFavorites.frame.size.height,
                noFavorites.frame.size.width,
                noFavorites.frame.size.height);

        UIImageView *logo = [[Model sharedModel] getLogoView];
        [self.view addSubview: logo];
    }
}





#pragma mark UITableViewDelegate


- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

    Toon *toon = [tableSource objectAtIndex: indexPath.row];
    NSString *cellId = [@"Cell" stringByAppendingString: toon.nid];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellId];

    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellId] autorelease];

        DesktopCell *cellView = [[[DesktopCell alloc] initWithFrame: CGRectMake(0, 0, 320, desktopCellHeight)] autorelease];
        cellView.toonObject = toon;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview: cellView];
    }

    return cell;
}


- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    return desktopCellHeight;
}


- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
    return tableSource.count;
}


- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    Toon *toon;
    toon = [tableSource objectAtIndex: indexPath.row];

    if (toon != controller.toonObject) {
        [controller release];
        controller = [[ToonDisplayViewController alloc] initWithNibName: @"ToonDisplayView" bundle: [NSBundle mainBundle]];
        controller.toonObject = toon;
    }

    [self.navigationController pushViewController: controller animated: YES];
}

@end
