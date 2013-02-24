//
//  GlassButton.h
//  
//  Created by Dani Postigo on 3/23/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import <Foundation/Foundation.h>


@interface GlassButton : UIButton {

    UIColor * _color;
    UIColor *_lightColor;
    UIColor *_highlightColor;
    UIColor *_darkColor;
    UIColor *_separatorColor;

    UILabel *titleLabel;
    NSString *text;

    UIImageView *imageView;
}


@property ( nonatomic, readonly ) UIColor * highlightColor;
@property ( nonatomic, readonly ) UIColor * lightColor;
@property ( nonatomic, readonly ) UIColor * darkColor;
@property ( nonatomic, readonly ) UIColor * separatorColor;
@property ( nonatomic, retain ) UIColor * color;
@property ( nonatomic, retain ) NSString * text;
@property ( nonatomic, retain ) UILabel * titleLabel;
@property ( nonatomic, retain ) UIImageView * imageView;

- (id) initWithText: (NSString *) aText;
- (id) initWithFrame: (CGRect) frame;
- (id) initWithFrame: (CGRect) frame string: (NSString *) string;


- (void) setLightColor: (UIColor *) aColor;
- (void) setDarkColor: (UIColor *) aColor;
- (void) setSeparatorColor: (UIColor *) aColor;
- (void) setHighlightColor: (UIColor *) aColor;

- (void) setColor: (UIColor *) aColor;

@end