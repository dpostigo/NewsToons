//
//  ToonDisplayViewController.h
//  NewsToons
//
//  Created by Daniela Postigo on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaveTwitterController.h"
#import "ToonDisplayView.h"
#import "TSMiniWebBrowser.h"

@class FaveTwitterController;

@interface ToonDisplayViewController : FaveTwitterController {
    ToonDisplayView *mainView;
    TSMiniWebBrowser *webBrowser;
    
}

@property (nonatomic, retain) ToonDisplayView *mainView;

- (void) handleExternalLink: (NSNotification *) notif;



@end
