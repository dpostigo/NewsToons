#import "SearchViewController.h"
#import "ToonDisplayViewController.h"
#import "Model.h"


@implementation SearchViewController

@synthesize activityView;
@synthesize mainTableView;
@synthesize contentsList;
@synthesize searchResults;
@synthesize savedSearchTerm;
@synthesize cells;


#pragma mark View lifecycle


- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = YES;

    if ( self.savedSearchTerm ) {
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
    else {
        [self refreshData];
     }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void) viewDidLoad {
    NSLog(@"%@ - %s", @"SearchViewController", sel_getName(_cmd));
    [super viewDidLoad];
    self.contentsList = [[[NSMutableArray alloc] init] autorelease];

    self.title = @"Search";
    self.view.backgroundColor = [UIColor blackColor];

    activityView.alpha = 0;
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration: 0.75];
    [UIView setAnimationDelegate: self];
    activityView.alpha = 1;
    [UIView commitAnimations];

    [self performSelector: @selector(delaySetup) withObject: nil afterDelay: 0.0];

}



- (void) viewDidUnload {
    [super viewDidUnload];
    self.savedSearchTerm = self.searchDisplayController.searchBar.text;
    self.searchResults = nil;
}


- (void) dealloc {
    [mainTableView release], mainTableView = nil;
    [contentsList release], contentsList = nil;
    [searchResults release], searchResults = nil;
    [savedSearchTerm release], savedSearchTerm = nil;

    [super dealloc];
}


- (void) resetViewController {
    [super resetViewController];
    [self.mainTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}


#pragma mark Data

- (void) refreshData {
    self.contentsList = [[[NSMutableArray alloc] initWithArray: [Model sharedModel].toonLibrary] autorelease];
    [self.mainTableView reloadData];
}

- (void) delaySetup {

    NSLog(@"%s", sel_getName(_cmd));

    self.mainTableView.rowHeight = 85;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.searchDisplayController.searchBar.scopeButtonTitles = nil;
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor blackColor];
    self.searchDisplayController.searchResultsTableView.rowHeight = [self mainTableView].rowHeight;
    self.searchDisplayController.searchResultsTableView.separatorColor = [UIColor blackColor];


    self.contentsList = [[[NSMutableArray alloc] initWithArray: [Model sharedModel].toonLibrary] autorelease];
    [self handleSavedTerm];


    [activityView stopAnimating];
    [activityView removeFromSuperview];
    [activityView release];


    self.mainTableView.alpha = 0;
    [self.mainTableView reloadData];
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration: 0.75];
    [UIView setAnimationDelegate: self];
    self.mainTableView.alpha = 1;
    [UIView commitAnimations];
}



#pragma mark -
#pragma mark UITableViewDataSource Methods

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    return desktopCellHeight;
}

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
    if ( tableView == self.searchDisplayController.searchResultsTableView ) {
        NSLog(@"[self.searchResults count] = %u", [self.searchResults count]);
        return [self.searchResults count];
    }

    NSLog(@"[self.contentsList count] = %u", [self.contentsList count]);
    return [self.contentsList count];

}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

    NSInteger row = [indexPath row];
    Toon * toon = nil;

    if ( tableView == self.searchDisplayController.searchResultsTableView ) toon = [self.searchResults objectAtIndex: row];
    else toon = [self.contentsList objectAtIndex: row];

    NSString *identifier = [@"search-identifier" stringByAppendingString: toon.title];
    ToonTableCell * cell = (ToonTableCell *) [tableView dequeueReusableCellWithIdentifier: identifier];

    if ( cell == nil ) {
        cell = [[ToonTableCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: identifier];
        cell.toonObject = toon;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSLog(@"cell = %@", cell);
    }

    return cell;
}


#pragma mark -
#pragma mark UITableViewDelegate Methods


- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

    [tableView deselectRowAtIndexPath: indexPath animated: YES];

    NSInteger row = [indexPath row];
    Toon * contentForThisRow = nil;

    if ( tableView == [[self searchDisplayController] searchResultsTableView] )
        contentForThisRow = [[self searchResults] objectAtIndex: row];
    else
        contentForThisRow = [[self contentsList] objectAtIndex: row];


    ToonDisplayViewController * controller = [[[ToonDisplayViewController alloc] initWithNibName: @"ToonDisplayView" bundle: [NSBundle mainBundle]] autorelease];
    controller.toonObject = contentForThisRow;
    [self.navigationController pushViewController: controller animated: YES];
}




#pragma mark Search

- (void) handleSavedTerm; {
    if ( [self savedSearchTerm] ) {
        [self.searchDisplayController.searchBar setText: self.savedSearchTerm];
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}



- (void) handleSearchForTerm: (NSString *) searchTerm {
    self.savedSearchTerm = searchTerm;
    if ( self.searchResults == nil ) {
        NSMutableArray * array = [[[NSMutableArray alloc] init] autorelease];
        self.searchResults = array;
    }

    [self.searchResults removeAllObjects];

    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"title contains[cd] %@", searchTerm];
    [self.searchResults addObjectsFromArray: [self.contentsList filteredArrayUsingPredicate: predicate]];

    predicate = [NSPredicate predicateWithFormat: @"self.tags contains[cd] %@", searchTerm];
    [self.searchResults addObjectsFromArray: [self.contentsList filteredArrayUsingPredicate: predicate]];

    /*
    if ( [[self savedSearchTerm] length] != 0 ) {
        for ( Toon * toon in [self contentsList] ) {
            NSMutableArray * termsToSearch = [[[NSMutableArray alloc] initWithArray: toon.tags] autorelease];


            [termsToSearch addObject: toon.title];

            for ( NSString * currentString in termsToSearch ) {
                if ( [currentString rangeOfString: searchTerm options: NSCaseInsensitiveSearch].location != NSNotFound ) {
                    [self.searchResults addObject: toon];
                    //LOG(@"Added: %@", toon.title);
                    break;
                }
            }

        }
    }

*/

}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods


- (BOOL) searchDisplayController: (UISearchDisplayController *) controller shouldReloadTableForSearchString: (NSString *) searchString {
    controller.searchResultsTableView.rowHeight = self.mainTableView.rowHeight;
    controller.searchResultsTableView.backgroundColor = [UIColor blackColor];
    controller.searchResultsTableView.frame = [self mainTableView].frame;
    controller.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    controller.searchResultsTableView.rowHeight = [self mainTableView].rowHeight;

    if ( [searchString isEqualToString: @""] ) {
        self.savedSearchTerm = nil;
        [self.mainTableView reloadData];
        return NO;
    }

    [self handleSearchForTerm: searchString];
    //[self.searchDisplayController.searchResultsTableView reloadTable];
    return YES;



}

- (void) searchDisplayControllerWillEndSearch: (UISearchDisplayController *) controller {
    self.savedSearchTerm = nil;
    [self.mainTableView reloadData];

}


@end
