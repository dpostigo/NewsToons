//
//  BadgeView.h
//  
//  Created by Dani Postigo on 3/26/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import <Foundation/Foundation.h>


@interface BadgeView : UIView {
    UIColor *badgeColor;
	UIFont *badgeFont;
    NSString *text;

}

@property ( nonatomic, retain ) UIColor * badgeColor;
@property ( nonatomic, retain ) UIFont *badgeFont;
@property ( nonatomic, retain ) NSString * text;


@end