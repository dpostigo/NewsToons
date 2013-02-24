//
//  LinksViewController.h
//  
//  Created by Dani Postigo on 3/26/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "LinksViewController.h"
#import "GradientUIView.h"
#import "UIView+Addons.h"
#import "UIView+Toons.h"
#import "Model.h"
#import "NSString+Addons.h"


@implementation LinksViewController {
    UITableView * table;
}

@synthesize tableSource;


- (id) initWithToonObject: (Toon *) aToonObject {
    self = [super init];
    if ( self ) {
        toonObject = [aToonObject retain];

        tableSource = [[NSMutableArray alloc] init];
        NSMutableArray * links = toonObject.moreInfoLinks;
        [tableSource addObjectsFromArray: links];


        self.view = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 480)];
        self.view.backgroundColor = [UIColor blackColor];

        UIImageView * background = [self.view quickBackgroundImage];
        [self.view insertSubview: background atIndex: 0];

        table = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.view.width, self.view.height) style: UITableViewStylePlain];
        //table.top = 100;
        //table.height -= 100;
		table.height -= 120;
        table.quickBackgroundImage.backgroundColor = [UIColor clearColor];
        table.quickBackgroundImage.opaque = NO;
        table.backgroundColor = [UIColor clearColor];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.clipsToBounds = YES;
        table.rowHeight = linkRowHeight;
		table.contentMode = UIViewContentModeScaleToFill;
        [table.quickBackgroundImage rasterize];
        table.delegate = self;
        table.dataSource = self;

        [self.view addSubview: table];


    }

    return self;
}

- (void) dealloc {
	table.delegate = nil;
	table.dataSource = nil;
    [toonObject release];
    [tableSource release];
    [table release];
    [self.view release];
    [super dealloc];
}

- (void)viewDidAppear: (BOOL)animated {
    [super viewDidAppear: animated];

    NSLog(@"self.navigationController = %@", self.navigationController);

}



#pragma mark UITableViewDelegate protocol



- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
    return tableSource.count;
}




- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

    NSUInteger row = (NSUInteger) indexPath.row;
    NSString *string = [tableSource objectAtIndex: row];
    NSString *identifier = [@"Cell" stringByAppendingString: string];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];


    if ( cell == nil ) {

        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: identifier] autorelease];
        cell.backgroundView = [[[UIView alloc] init] autorelease];
        cell.backgroundView.backgroundColor = [UIColor clearColor];


        CGRect bgRect;
        GradientUIView * styledBg;



        bgRect = CGRectMake(0, 0, tableView.width, linkRowHeight);
        styledBg = [[[GradientUIView alloc] initWithFrame: bgRect] autorelease];
        styledBg.opaque = NO;
        styledBg.separatorColor = [UIColor blackColor];
        styledBg.lightSeparatorColor = [UIColor colorWithWhite: 0.35 alpha: 1.0];


        [self.view formatTextLabel: cell.textLabel string: string];
        cell.imageView.image = [self.model getPressIcon: [string stripURLString]];
        cell.imageView.left = cell.imageView.left + 10;
        cell.detailTextLabel.text = string;



        [cell.quickBackgroundImage addSubview: styledBg];
        cell.contentView.backgroundColor = [UIColor clearColor];


        cell.detailTextLabel.font = [cell.textLabel.font fontWithSize: 10.0];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"white-disclosure-indicator.png"]] autorelease];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }


    return cell;
}


- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    NSString *string = [tableSource objectAtIndex: indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"ExternalLink" object: nil userInfo: [NSDictionary dictionaryWithObject: string forKey: @"String"]];
    [table deselectRowAtIndexPath: indexPath animated: YES];

}


@end