//
//  SampleViewController.h
//  SlickTeachesTableViews
//
//  Created by Brian Slick on 1/26/10.
//  Copyright 2010 BriTer Ideas LLC. All rights reserved.
//  
//  This sample was downloaded from:
//  http://clingingtoideas.blogspot.com/
//

#import <UIKit/UIKit.h>
#import "ToonTableCell.h"
#import "ToonDisplayView.h"
#import "BasicViewController.h"

@interface SearchViewController : BasicViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate> {
    
	UITableView *mainTableView;
	
	NSMutableArray *contentsList;
	NSMutableArray *searchResults;
	NSMutableArray *cells;
	NSString *savedSearchTerm;
    
    IBOutlet UIView *dummyDisplay;
    IBOutlet UIActivityIndicatorView *activityView;
    ToonDisplayView *padDisplay;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityView;
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) NSMutableArray *contentsList;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, retain) NSMutableArray *cells;
@property (nonatomic, copy) NSString *savedSearchTerm;


- (void) handleSavedTerm;
- (void) handleSearchForTerm:(NSString *)searchTerm;



@end
