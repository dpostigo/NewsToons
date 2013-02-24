//
//  NewsToonsAppDelegate.h
//  NewsToons
//
//  Created by Daniela Postigo on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"


@interface NewsToonsAppDelegate : UIResponder <UIApplicationDelegate,
        UITabBarControllerDelegate,
        FBSessionDelegate> {

    IBOutlet UIWindow *window;
    IBOutlet UITabBarController * tabController;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabController;


@end
