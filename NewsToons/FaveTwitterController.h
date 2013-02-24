//
//  FaveTwitterController.h
//  NewsToons
//
//  Created by Daniela Postigo on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "Twitter/Twitter.h"
#import "FBConnect.h"

#import "FavoriteViewController.h"
#import "URLShortener.h"
#import "URLShortenerCredentials.h"


@interface FaveTwitterController : FavoriteViewController <URLShortenerDelegate,
        MFMailComposeViewControllerDelegate,
        FBDialogDelegate> {
	
	UIButton *facebookButton;
	UIButton *twitterButton;
	UIButton *sendButton;

    UIActivityIndicatorView * activityView;
	
}


@property (nonatomic, retain) UIButton *twitterButton;
@property (nonatomic, retain) UIButton *facebookButton;
@property (nonatomic, retain) UIButton *sendButton;
@property(nonatomic, retain) UIActivityIndicatorView *activityView;

- (void) postToFacebook:(id)sender;
- (void) postToTwitter:(id)sender;
- (void) sendToFriend:(id)sender;


@end
