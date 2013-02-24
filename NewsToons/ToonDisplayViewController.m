//
//  ToonDisplayViewController.m
//  NewsToons
//
//  Created by Daniela Postigo on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ToonDisplayViewController.h"
#import "LinksViewController.h"
#import "Model.h"


@implementation ToonDisplayViewController {
    LinksViewController *linksController;
}


@synthesize mainView;


- (void) dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (linksController) [linksController release];

    [super dealloc];
}


- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {

    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {

        [self initializeBasics];
        self.view = self.mainView;
        self.navigationController.navigationBar.hidden = YES;

        plusImage = @"heart-icon.png";
        heartImage = @"heart-tray-icon.png";

        self.favoriteButton = mainView.favoriteButton;
        self.twitterButton = mainView.twitterButton;
        self.facebookButton = mainView.facebookButton;
        self.sendButton = mainView.sendButton;

        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(handleExternalLink:) name: @"ExternalLink" object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(viewAllLinks:) name: @"ViewAllLinks" object: nil];
    }

    return self;
}


- (void) viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(youTubeVideoExit:)
                                                 name: @"UIMoviePlayerControllerDidExitFullscreenNotification"
                                               object: nil];
}


- (void) youTubeVideoExit: (id) sender {

    NSLog(@"%s", __PRETTY_FUNCTION__);
    //    [[UIApplication sharedApplication] setStatusBarOrientation: UIIN animated: NO];

//    [[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationPortrait animated: NO];
}



#pragma mark - View lifecycle



- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];
    [self.view addSubview: toonObject.videoView];

    //        [[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationPortrait animated: NO];
}


- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];


    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {

        NSLog(@"IS PORTRAIT");
    }

    else {

        NSLog(@"NOT PORTRAIT, setStatusBarOrientation ");
        [[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationPortrait animated: NO];
    }





    [self.navigationController setNavigationBarHidden: NO animated: YES];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    if ([toonObject.moreInfoLinks count] == 0) [mainView revealDescription];
}


- (void) viewDidDisappear: (BOOL) animated {
    [super viewDidDisappear: animated];
}


- (void) viewWillDisappear: (BOOL) animated {
    [super viewWillDisappear: animated];

    NSLog(@"ALLOWING LANDSCAPE");
    _model.shouldSupportLandscape = YES;
}


- (void) viewDidUnload {
    [super viewDidUnload];
    [self.navigationController setNavigationBarHidden: YES animated: NO];
}


- (ToonDisplayView *) mainView {
    if (!mainView) {
        CGRect deviceFrame = CGRectMake(0, 0, 320, 460);
        //if ( IPAD ) deviceFrame = CGRectMake(0, 0, 768, 1024);
        mainView = [[ToonDisplayView alloc] initWithFrame: deviceFrame];
    }
    return mainView;
}


- (void) setToonObject: (Toon *) toon {

    [super setToonObject: toon];
    self.title = toonObject.title;
    mainView.toonObject = toonObject;
}


- (void) handleExternalLink: (NSNotification *) notif {

    NSString *string;
    NSString *encodedString;

    string = [notif.userInfo valueForKey: @"String"];
    encodedString = [string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];

    if (!webBrowser) {
        webBrowser = [[TSMiniWebBrowser alloc] initWithUrl: [NSURL URLWithString: encodedString]];
        webBrowser.showURLStringOnActionSheetTitle = YES;
        webBrowser.showPageTitleOnTitleBar = YES;
        webBrowser.showActionButton = YES;
        webBrowser.showReloadButton = YES;
        webBrowser.barStyle = UIBarStyleBlack;
        webBrowser.mode = TSMiniWebBrowserModeModal;
    }

    else {
        [webBrowser reloadWithURL: [NSURL URLWithString: encodedString]];
    }

    [self presentModalViewController: webBrowser animated: YES];
}


- (void) viewAllLinks: (NSNotification *) notif {

    if (!linksController) linksController = [[LinksViewController alloc] initWithToonObject: self.toonObject];

    @try {
        NSLog(@"All clear.");
        [self.navigationController pushViewController: linksController animated: NO];
    }
    @catch (NSException *ex) {

        NSLog(@"Exception: [%@]:%@", [ex class], ex);
        NSLog(@"ex.name:'%@'", ex.name);
        NSLog(@"ex.reason:'%@'", ex.reason);

        NSRange range = [ex.reason rangeOfString: @"Pushing the same view controller instance more than once is not supported"];

        if ([ex.name isEqualToString: @"NSInvalidArgumentException"] && range.location != NSNotFound) {
            [self.navigationController popToViewController: linksController animated: NO];
        } else {
            NSLog(@"ERROR:UNHANDLED EXCEPTION TYPE:%@", ex);
        }
    }
    @finally {
        //NSLog(@"finally");
    }
}


- (void) toonDidUpdate: (Toon *) aToon {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    if (aToon == toonObject) {
        [mainView.infoCell.emailLabel performSelector: @selector(setText:) withObject: [NSString stringWithFormat: @"%d", toonObject.emailCount] afterDelay: 1.5];
        [mainView.infoCell.emailLabel performSelector: @selector(sizeToFit) withObject: nil afterDelay: 1.6];
    }
}

@end
