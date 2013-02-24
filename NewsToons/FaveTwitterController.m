//
//  FaveTwitterController.m
//  NewsToons
//
//  Created by Daniela Postigo on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FaveTwitterController.h"
#import "Model.h"
#import "UpdateCloud.h"


@interface FaveTwitterController ()

- (void) tweetShortenedURL: (NSURL *) shortenedURL;
- (void) shortener: (URLShortener *) shortener didSucceedWithShortenedURL: (NSURL *) shortenedURL;
- (void) shortener: (URLShortener *) shortener didFailWithStatusCode: (int) statusCode;
- (void) shortener: (URLShortener *) shortener didFailWithError: (NSError *) error;


@end


@implementation FaveTwitterController

@synthesize twitterButton;
@synthesize facebookButton;
@synthesize sendButton;

@synthesize activityView;

- (void) dealloc {
    [activityView release];
    [facebookButton release];
    [twitterButton release];
    [sendButton release];
    [super dealloc];
}


- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


- (void) setTwitterButton: (UIButton *) button {

    if ( twitterButton != button ) {
        [button retain];
        [twitterButton removeTarget: self action: @selector(postToTwitter:) forControlEvents: UIControlEventTouchUpInside];
        [twitterButton release];
        twitterButton = button;
        [twitterButton addTarget: self action: @selector(postToTwitter:) forControlEvents: UIControlEventTouchUpInside];

    }

}

- (void) setFacebookButton: (UIButton *) button {

    if ( facebookButton != button ) {
        [button retain];
        [facebookButton release];
        facebookButton = button;
        [facebookButton addTarget: self action: @selector(postToFacebook:) forControlEvents: UIControlEventTouchUpInside];

    }

}

- (void) setSendButton: (UIButton *) button {
    if ( sendButton != button ) {
        [button retain];
        [sendButton release];
        sendButton = button;
        [sendButton addTarget: self action: @selector(sendToFriend:) forControlEvents: UIControlEventTouchUpInside];

    }

}





/* * * *         Twitter        * * * */

- (void) postToTwitter: (id) sender {

    activityView = [[UIActivityIndicatorView alloc] initWithFrame: self.view.frame];
    activityView.backgroundColor = [UIColor colorWithWhite: 0.1 alpha: 0.5];
    [self.view addSubview: activityView];
    [activityView startAnimating];


    URLShortener * shortener = [[URLShortener new] autorelease];
    if ( shortener != nil ) {

        URLShortenerCredentials * credentials;
        credentials = [[[URLShortenerCredentials alloc] init] autorelease];
        credentials.login = @"elasticcreative";
        credentials.key = @"R_9a756514d91de397aa750c89b7d81223";


        shortener.delegate = self;
        shortener.credentials = credentials;
        shortener.url = [NSURL URLWithString: toonObject.youtubeString];
        [shortener execute];
    }


}



#pragma mark URLShortenerDelegate -

- (void) shortener: (URLShortener *) shortener didSucceedWithShortenedURL: (NSURL *) shortenedURL {

    NSLog(@"URLShortener did succeed.");
    [self tweetShortenedURL: shortenedURL];
    shortener.delegate = nil;


}

- (void) shortener: (URLShortener *) shortener didFailWithStatusCode: (int) statusCode {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);
    shortener.delegate = nil;
}


- (void) shortener: (URLShortener *) shortener didFailWithError: (NSError *) error {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);
    shortener.delegate = nil;
}



- (void) tweetShortenedURL: (NSURL *) shortenedURL {


    [activityView stopAnimating];

    NSString * tweetString = [[[NSString alloc] initWithFormat: @"%@ by @MarkFiore - %@", toonObject.title, shortenedURL.absoluteString] autorelease];


    if ([TWTweetComposeViewController canSendTweet]) {


        TWTweetComposeViewController * controller = [[[TWTweetComposeViewController alloc] init] autorelease];

        [controller setInitialText: tweetString];

        TWTweetComposeViewControllerCompletionHandler
                completionHandler =
                ^(TWTweetComposeViewControllerResult result) {
                    switch (result)
                    {
                        case TWTweetComposeViewControllerResultCancelled:
                            NSLog(@"Twitter Result: canceled");
                            [self.navigationController dismissModalViewControllerAnimated: YES];
                            break;
                        case TWTweetComposeViewControllerResultDone:
                            NSLog(@"Twitter Result: sent");



                            [self.navigationController dismissModalViewControllerAnimated: YES];
                            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle: @"Twitter Status" message: @"Successfully sent your tweet." delegate: nil cancelButtonTitle: @"Okay" otherButtonTitles: nil] autorelease];
                            [alert show];

                            break;

                        default:
                            NSLog(@"Twitter Result: default");
                            break;
                    }
                    [self dismissModalViewControllerAnimated:YES];
                };


        [controller setCompletionHandler:completionHandler];



        [self presentModalViewController: controller animated: YES];
    } else {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle: @"Twitter Status" message: @"There was a problem with your Twitter accounts. Please check that you are logged in correctly." delegate: self cancelButtonTitle: @"Okay" otherButtonTitles: nil] autorelease];
        [alert show];
    }


}



/* * * *         Mail / Send To a Friend        * * * */


- (void) sendToFriend: (id) sender {

    NSString * youtubeLink = [NSString stringWithFormat: @"<a href=\"http:/www.youtube.com/watch?v=%@\">%@</a>", toonObject.youtubeId, toonObject.title];
    NSString * appLink = [NSString stringWithFormat: @"Click here to get the <a href=\"%@\">NewsToons</a> app!", WEB_APP_URL];
    NSString * messageText  = [[[NSString alloc] initWithFormat: @" Check out this Mark Fiore animation:<br />%@<br /> <br /> %@", youtubeLink, appLink] autorelease];
    NSString * subject = [[[NSString alloc] initWithFormat: @"%@ on NewsToons", toonObject.title] autorelease];

    MFMailComposeViewController * mail;
    mail = [[[MFMailComposeViewController alloc] init] autorelease];
    mail.mailComposeDelegate = self;
    [mail setSubject: subject];
    [mail setMessageBody: messageText isHTML: YES];

    [self presentModalViewController: mail animated: YES];

}

- (void) mailComposeController: (MFMailComposeViewController *) controller didFinishWithResult: (MFMailComposeResult) result error: (NSError *) error {

    switch (result) {
        case MFMailComposeResultCancelled:
            //message.text = @"Result: canceled";
            NSLog(@"EMAIL CANCELED.");

            break;
        case MFMailComposeResultSaved:
            //message.text = @"Result: saved";
            break;
        case MFMailComposeResultSent:
            //message.text = @"Result: sent";
            NSLog(@"EMAIL SENT.");
            toonObject.emailCount++;
            UpdateCloud *operation = [[[UpdateCloud alloc] initWithToon: toonObject] autorelease];
            [[NSOperationQueue mainQueue] addOperation: operation];
            break;
        case MFMailComposeResultFailed:
            //message.text = @"Result: failed";
            break;
        default:
            //message.text = @"Result: not sent";
            break;
    }
    [self dismissModalViewControllerAnimated: YES];
}








#pragma mark Facebook -

- (void) postToFacebook: (id) sender {

    Facebook *facebook = self.model.facebook;
    NSString * thumbnailString = [toonObject.youtubeThumbnail absoluteString];

    NSMutableDictionary * params;
    params = [[[NSMutableDictionary alloc] init] autorelease];
    [params setObject: kFacebookAppId forKey: @"app_id"];
    [params setObject: toonObject.title forKey: @"name"];
    [params setObject: toonObject.title forKey: @"caption"];
    [params setObject: toonObject.descriptionText forKey: @"description"];
    [params setObject: thumbnailString forKey: @"picture"];
    [params setObject: [NSString stringWithFormat: YOUTUBE_VIDEO_URL, toonObject.youtubeId] forKey: @"link"];

    [facebook dialog: @"feed" andParams: params andDelegate: self];


}


#pragma mark FBDialogDelegate -


- (void) dialogDidComplete: (FBDialog *) dialog {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);
    dialog.delegate = nil;
}

- (void) dialogCompleteWithUrl: (NSURL *) url {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);

}

- (void) dialogDidNotCompleteWithUrl: (NSURL *) url {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);

}

- (void) dialogDidNotComplete: (FBDialog *) dialog {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);
    dialog.delegate = nil;

}

- (void) dialog: (FBDialog *) dialog didFailWithError: (NSError *) error {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);
    dialog.delegate = nil;

}

- (BOOL) dialog: (FBDialog *) dialog shouldOpenURLInExternalBrowser: (NSURL *) url {
    return NO;

}

#pragma mark FBLoginDialogDelegate -


- (void) fbDialogLogin: (NSString *) token expirationDate: (NSDate *) expirationDate {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);
}

- (void) fbDialogNotLogin: (BOOL) cancelled {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);

}






#pragma mark FBSessionDelegate -

- (void) fbDidLogin {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);

}

- (void) fbDidNotLogin: (BOOL) cancelled {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);

}

- (void) fbDidExtendToken: (NSString *) accessToken expiresAt: (NSDate *) expiresAt {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);

}

- (void) fbDidLogout {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);

}

- (void) fbSessionInvalidated {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);

}


@end
