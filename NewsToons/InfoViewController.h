//
//  InfoViewController.h
//  NewsToons
//
//  Created by Daniela Postigo on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"

@class BasicViewController;

@interface InfoViewController : BasicViewController <UIWebViewDelegate> {
    
	NSString *bioName;
    IBOutlet UIWebView *webView;
    IBOutlet UIImageView *bgImage;
}

- (void) handleSetup;
- (void) loadHTMLFile;

@end
