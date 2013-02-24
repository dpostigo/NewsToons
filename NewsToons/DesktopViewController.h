//
//  DesktopViewController.h
//  NewsToons
//
//  Created by Daniela Postigo on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"
#import "ToonDisplayView.h"
#import "ToonDisplayViewController.h"
#import "DesktopCell.h"

@class BasicViewController;

@interface DesktopViewController : BasicViewController <UITableViewDelegate, UITableViewDataSource> {

    ToonDisplayViewController *toonDisplayController;

    IBOutlet UILabel *noFavorites;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView *backgroundImage;
}

@property (nonatomic, retain) ToonDisplayViewController *toonDisplayController;


- (void) updateFavorites;
- (void) handleDisplaySetup;






@end
