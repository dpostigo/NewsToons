//
//  ${HEADER_FILENAME}
//  
//  Created by Dani Postigo on 3/29/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "ToonLibrarySortMode.h"

@protocol ToonListDelegate <NSObject>


- (void) initTable;
- (void) reloadTable;
- (UIView *) tableFooterView;

- (void) handleLoadMore: (id) sender;
- (void) reloadAllToons;
- (void) setSortMode: (ToonLibrarySortMode) mode;

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath;

    @end