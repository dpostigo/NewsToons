//
//  SplashView.m
//  NewsToons
//
//  Created by Daniela Postigo on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SplashView.h"
#import "UIView+Addons.h"
#import "UIImage+Addons.h"

@implementation SplashView {
    UILabel * label;
    TKProgressCircleView * circle;
}

@synthesize circle;
@synthesize label;
@synthesize isVisible;
@synthesize isAnimating;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        isVisible = YES;
        self.backgroundColor = [UIColor blackColor];


        UIImageView *aBackground = [[[UIImageView alloc] initWithImage: [[UIImage newImageFromResource: @"background.png"] autorelease]] autorelease];
        aBackground.frame = frame;

        [self addSubview: aBackground];

        //UILabel *label;
        label = [[UILabel alloc] initWithFrame: frame];
        label.height = 50;
        label.textAlignment = UITextAlignmentCenter;
        label.text = @"Loading content from markfiore.com ...  ";
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.width = self.width / 2;
        label.centerX = self.centerX;
        label.centerY = self.centerY - (self.height/4);
        label.numberOfLines = 0;
        label.font = [UIFont boldSystemFontOfSize: 13.0];
        [self addSubview: label];

        //TKProgressCircleView *circle;
        self.circle = [[[TKProgressCircleView alloc] initWithFrame: label.frame] autorelease];
        circle.top = label.bottom + 10;
        circle.centerX = self.centerX;
        circle.twirlMode = YES;
        circle.repeat = YES;
        [self addSubview: circle];

 /*

        aBackground.alpha = 0;
        label.alpha = 0;
        circle.alpha = 0;


        [UIView animateWithDuration: 0.5 animations: ^{
            defaultImg.alpha = 0;
            aBackground.alpha = 0.8;
            label.alpha = 1;

        } completion: nil];


        [UIView animateWithDuration: 0.5 delay: 0.5 options: UIViewAnimationOptionCurveEaseIn animations: ^{
            circle.alpha = 1;

        } completion: nil];

        */

    }
    return self;
}




- (void) setText:(NSString *)text {
	label.text = text;
}

- (void) fadeOut {
    circle.twirlMode = NO;


    [UIView animateWithDuration: 0.5 animations: ^{
        circle.alpha = 0;
    }];






    [UIView beginAnimations: @"" context: nil];
    [UIView setAnimationDuration: 0.5];
    [UIView setAnimationDelay: 0.5];
    [UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:)];

    label.alpha = 0;
    circle.alpha = 0;
    [UIView commitAnimations];


    [UIView beginAnimations: @"" context: nil];
    [UIView setAnimationDuration: 0.5];
    [UIView setAnimationDelay: 1.0];
    self.alpha = 0;
    [UIView commitAnimations];
}



- (void) animationDidComplete {

}


- (void) dealloc {

    [label release];
    [circle release];
    [super dealloc];
}


@end
