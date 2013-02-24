//
// Created by dpostigo on 12/12/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TabBarController.h"
#import "Model.h"


@implementation TabBarController {
}


- (BOOL) shouldAutorotate {

    BOOL shouldRotate = [Model sharedModel].shouldSupportLandscape;

    if (!shouldRotate) {
        if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait) {
            return YES;
        }
    }
    return shouldRotate;
}


- (NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end