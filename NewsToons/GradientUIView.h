//
//  GradientUIView.h
//  CoolTable
//
//  Created by Ray Wenderlich on 9/29/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UIViewStyleGlossy,
    UIViewStyleGradient,
} UIViewStyle;

@interface GradientUIView : UIView {

    UIViewStyle style;

    BOOL drawsBorder;
    BOOL drawsFill;
    BOOL drawsSeparator;

    UIColor *borderColor;
    UIColor *lightFillColor;
    UIColor *darkFillColor;
    UIColor *separatorColor;
    UIColor *lightSeparatorColor;

    CGRect _coloredBoxRect;
    CGRect _paperRect;

    CGFloat padding;
}

@property ( nonatomic, assign ) BOOL drawsSeparator;
@property ( nonatomic, assign ) BOOL drawsBorder;
@property ( nonatomic, assign ) BOOL drawsFill;

@property ( nonatomic, retain ) UIColor *borderColor;
@property ( nonatomic, retain ) UIColor *lightFillColor;
@property ( nonatomic, retain ) UIColor *darkFillColor;
@property ( nonatomic, retain ) UIColor *separatorColor;
@property ( nonatomic, retain ) UIColor *lightSeparatorColor;

@property ( nonatomic, assign ) UIViewStyle style;
@property ( nonatomic, assign ) CGFloat padding;



- (id) initWithFrame: (CGRect) frame;
- (void) setFrame: (CGRect) aFrame;



- (void) drawGlossy;

- (void) drawGradient;
- (void) drawGradientFill: (CGContextRef) context paperRect: (CGRect) paperRect;
- (void) drawBorder: (CGContextRef) context paperRect: (CGRect) paperRect;
- (void) drawSeparator: (CGContextRef) context paperRect: (CGRect) paperRect;


@end
