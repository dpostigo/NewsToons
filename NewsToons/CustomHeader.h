//
//  CustomHeader.h
//  CoolTable
//
//  Created by Ray Wenderlich on 9/29/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomHeader : UIView {
    UILabel *_titleLabel;
    UIColor *_lightColor;
    UIColor *_darkColor;
    CGRect _coloredBoxRect;
    CGRect _paperRect;
}

@property (retain) UILabel *titleLabel;
@property (retain) UIColor *lightColor;
@property (retain) UIColor *darkColor;

@end
