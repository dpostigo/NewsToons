//
//  NewsToonsAppDelegate.m
//  NewsToons
//
//  Created by Daniela Postigo on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsToonsAppDelegate.h"
#import "Model.h"
#import "Cocoafish.h"
#import "BasicViewController.h"


#define COCOAFISH_APP_KEY @"lQ9ED6mVl8PmWXx8FG5z4jpMvpqlGVaU"
#define COCOAFISH_OAUTH_CONSUMER_KEY @"pTY7CtAVWHAaXAc9jyJwo1jyTf5X7HGU"
#define COCOAFISH_OAUTH_CONSUMER_SECRET @"sTcdcMzKS6Twi1ci9YIuWlk4P1AeBbkL"


@implementation NewsToonsAppDelegate {
    NSUInteger _selectedIndex;
}

@synthesize window;
@synthesize tabController;


- (void) dealloc {
    [window release];
    [tabController release];
    [super dealloc];
}

- (void) customizeAppearance {
    UIFont * font;
    NSDictionary * dictionary;

    font = [UIFont boldSystemFontOfSize: 14.0];
    dictionary = [NSDictionary dictionaryWithObject: font forKey: UITextAttributeFont];

    [[UINavigationBar appearance] setTitleTextAttributes: dictionary];
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated: NO];

}


- (BOOL) application: (UIApplication *) application didFinishLaunchingWithOptions: (NSDictionary *) launchOptions {

    [Cocoafish initializeWithOauthConsumerKey: COCOAFISH_OAUTH_CONSUMER_KEY consumerSecret: COCOAFISH_OAUTH_CONSUMER_SECRET customAppIds: nil];
    [Cocoafish defaultCocoafish].loggingEnabled = NO;

    if ( launchOptions != nil ) {
        NSLog(@"launchOptions = %@", launchOptions);
        NSDictionary * dictionary = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
        if ( dictionary != nil ) {
            NSLog(@"Launched from push notification: %@", dictionary);

        }
    }


    [self customizeAppearance];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor blackColor];

    Model * _model = [Model sharedModel];
    [_model getEmailedToons];
    _model.facebook = [[Facebook alloc] initWithAppId: kFacebookAppId andDelegate: self];


    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:  UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound ];



    return YES;
}




#pragma mark Remote notifications

- (void) application: (UIApplication *) application didRegisterForRemoteNotificationsWithDeviceToken: (NSData *) deviceToken {


	NSString * newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString: @"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString: @" " withString: @""];


	// Add to Appcelerator Cloud Services
	[[Cocoafish defaultCocoafish] setDeviceToken: newToken];

	NSMutableDictionary * paramDict = [NSMutableDictionary dictionaryWithCapacity: 3];
	[paramDict setObject: @"mychannel3" forKey: @"channel"];
	[paramDict setObject: newToken forKey: @"device_token"];
	CCRequest * request = [[CCRequest alloc] initWithDelegate: self httpMethod: @"POST" baseUrl: @"push_notification/subscribe.json" paramDict: paramDict];
	[request startAsynchronous];
	[request release];
}

- (void) application: (UIApplication *) application didFailToRegisterForRemoteNotificationsWithError: (NSError *) error {

    NSLog(@"Failed to get token, error: %@", error);

    UIAlertView * alert = [[[UIAlertView alloc] initWithTitle: @"Error" message: @"Could not register for push." delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil] autorelease];
    [alert show];

}

- (void) application: (UIApplication *) application didReceiveRemoteNotification: (NSDictionary *) userInfo {
    NSLog(@"Received notification: %@", userInfo);
    //[self addMessageFromRemoteNotification:userInfo updateUI:YES];
}


- (void) applicationWillResignActive: (UIApplication *) application {
}

- (void) applicationDidEnterBackground: (UIApplication *) application {

}

- (void) applicationWillEnterForeground: (UIApplication *) application {

    if ( [UIApplication sharedApplication].applicationIconBadgeNumber > 0 ) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    }


}

- (void) applicationDidBecomeActive: (UIApplication *) application {
}

- (void) applicationWillTerminate: (UIApplication *) application {
}


- (BOOL) application: (UIApplication *) application handleOpenURL: (NSURL *) url {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);
    return [[Model sharedModel].facebook handleOpenURL: url];
}

- (BOOL) application: (UIApplication *) application openURL: (NSURL *) url
   sourceApplication: (NSString *) sourceApplication annotation: (id) annotation {

    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);
    return [[Model sharedModel].facebook handleOpenURL: url];
}


#pragma mark Facebook -



- (void) fbDidLogin {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: [[Model sharedModel].facebook accessToken] forKey: @"FBAccessTokenKey"];
    [defaults setObject: [[Model sharedModel].facebook expirationDate] forKey: @"FBExpirationDateKey"];
    [defaults synchronize];

}


- (void) fbDidNotLogin: (BOOL) cancelled; {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);
}


- (void) fbDidExtendToken: (NSString *) accessToken expiresAt: (NSDate *) expiresAt {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);

}

- (void) fbSessionInvalidated {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);

}

- (void) fbDidLogout; {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);

}


#pragma mark UITabBarControllerDelegate -



- (void) tabBarController: (UITabBarController *) tabBarController didSelectViewController: (UIViewController *) viewController {

    if ( _selectedIndex == tabBarController.selectedIndex){
        UINavigationController * navigationController = (UINavigationController *) viewController;
        BasicViewController * controller = [navigationController.viewControllers objectAtIndex: 0];
        [controller resetViewController];

    } else {
        UINavigationController * controller = [tabBarController.viewControllers objectAtIndex: 0];
        [controller popToRootViewControllerAnimated: NO];
        [controller setNavigationBarHidden: YES animated: NO];
    }

    _selectedIndex = tabBarController.selectedIndex;
}


@end
