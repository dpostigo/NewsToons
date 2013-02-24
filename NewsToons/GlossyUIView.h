//
//  ${FILENAME}
//  
//  Created by Dani Postigo on 3/22/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import <Foundation/Foundation.h>

@interface GlossyUIView : UIView {
    UIColor * _color;
    UIColor *_lightColor;
    UIColor *_highlightColor;
    UIColor *_darkColor;
    UIColor *_separatorColor;

    UILabel *_titleLabel;
    CGRect _paperRect;

    UIButton *button;
}

@property (retain) UILabel *titleLabel;

@property ( nonatomic, readonly ) UIColor * highlightColor;
@property ( nonatomic, readonly ) UIColor * lightColor;
@property ( nonatomic, readonly ) UIColor * darkColor;
@property ( nonatomic, readonly ) UIColor * separatorColor;
@property ( nonatomic, readonly ) UIColor * color;


- (void) setLightColor: (UIColor *) aColor;
- (void) setDarkColor: (UIColor *) aColor;
- (void) setSeparatorColor: (UIColor *) aColor;
- (void) setHighlightColor: (UIColor *) aColor;

- (void) setColor: (UIColor *) aColor;


@end
