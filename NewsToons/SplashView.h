//
//  SplashView.h
//  NewsToons
//
//  Created by Daniela Postigo on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKProgressCircleView.h"

@interface SplashView : UIView {

    UIImageView * defaultImg;
    BOOL isVisible;
    BOOL isAnimating;
    
}

@property ( nonatomic, retain ) TKProgressCircleView * circle;
@property ( nonatomic, retain ) UILabel * label;
@property ( nonatomic ) BOOL isVisible;
@property ( nonatomic ) BOOL isAnimating;


- (void) fadeOut;


@end
