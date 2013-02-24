//
//  GlassButton.m
//  
//  Created by Dani Postigo on 3/23/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "GlassButton.h"
#import "UIViewStyles.h"
#import "UIView+Addons.h"


@implementation GlassButton {

}

@synthesize highlightColor = _highlightColor;
@synthesize lightColor = _lightColor;
@synthesize darkColor = _darkColor;
@synthesize separatorColor = _separatorColor;
@synthesize color = _color;
@synthesize text;
@synthesize titleLabel;
@synthesize imageView;


- (id) initWithText: (NSString *) aText {
    return [self initWithFrame: CGRectMake(0, 0, 320, 40) string: aText];
}

- (id) initWithFrame: (CGRect) frame {
    return [self initWithFrame: frame string: @""];
}



- (id) initWithFrame: (CGRect) frame string: (NSString * ) string {

    self = [super initWithFrame: frame];
    if ( self ) {

        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;

        self.titleLabel = [[UILabel alloc] initWithFrame: frame];
        self.titleLabel.text = string;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize: 11.0];
        self.titleLabel.textAlignment = UITextAlignmentCenter;

        self.lightColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
        self.darkColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0];
        self.separatorColor = [UIColor blackColor];
        self.highlightColor = [UIColor whiteColor];

    }

    return self;
}


- (void) setImageView: (UIImageView *) imgView {
    if ( imageView != imgView ) {
        [imgView retain];

        if (imageView.superview) [imageView removeFromSuperview];
        [imageView release];
        imageView = imgView;

        imgView.left = titleLabel.right + 10;
    }

}


- (void) setText: (NSString *) aText {
    text = aText;
    self.titleLabel.text = text;
}

- (void) setColor: (UIColor *) aColor {
    if (aColor != _color){
        [aColor retain];
        [_color release];
        _color = aColor;
    }

    if ( _color == [UIColor blackColor] ) {

        self.highlightColor = [UIColor colorWithWhite: 0.2 alpha: 1.0];
        self.lightColor = [UIColor colorWithWhite: 0.3 alpha: 1.0];
        self.darkColor = [UIColor blackColor];
    }

    else if ( _color == [UIColor whiteColor] ) {

        self.highlightColor = [UIColor colorWithWhite: 0.0 alpha: 1.0];
        self.lightColor = [UIColor colorWithWhite: 0.1 alpha: 1.0];
        self.darkColor = [UIColor colorWithWhite: 0.3 alpha: 1.0];
    }


    else if ( _color == [UIColor clearColor] ) {

        self.highlightColor = [UIColor colorWithWhite: 0.2 alpha: 1.0];
        self.lightColor = [UIColor colorWithWhite: 0.3 alpha: 1.0];
        self.darkColor = [UIColor blackColor];
    }

}

- (void) setLightColor: (UIColor *) aColor {

    if (aColor != _lightColor){
        [aColor retain];
        [_lightColor release];
        _lightColor = aColor;
    }
}


- (void) setDarkColor: (UIColor *) aColor {
    if (aColor != _darkColor){
        [aColor retain];
        [_darkColor release];
        _darkColor = aColor;
    }
}


- (void) setSeparatorColor: (UIColor *) aColor {
    if (aColor != _separatorColor){
        [aColor retain];
        [_separatorColor release];
        _separatorColor = aColor;
    }

}

- (void) setHighlightColor: (UIColor *) aColor {
    if (aColor != _highlightColor){
        [aColor retain];
        [_highlightColor release];
        _highlightColor = aColor;
    }

}


- (void) setHighlighted: (BOOL) highlighted {
    BOOL old = self.highlighted;
    [super setHighlighted: highlighted];

    if ( old != highlighted )
        [self setNeedsDisplay];

}




- (void)drawRect:(CGRect)rect {

    [titleLabel removeFromSuperview];
    if (imageView.superview) [imageView removeFromSuperview];

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGColorRef highlightColor = _highlightColor.CGColor;
    CGColorRef lightColor = _lightColor.CGColor;
    CGColorRef darkColor = _darkColor.CGColor;
    //CGColorRef separatorColor = _separatorColor.CGColor;

    CGRect paperRect = self.bounds;

	// Draw paper
    CGContextSetFillColorWithColor(context, highlightColor);
    CGContextFillRect(context, paperRect);

    // Draw shadow
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 3.0, darkColor);
    CGContextSetFillColorWithColor(context, lightColor);

    CGContextFillRect(context, paperRect);
    CGContextRestoreGState(context);

    // Draw gloss and gradient
    //CGColorRef whiteColor = [UIColor whiteColor].CGColor;
    //drawGlossAndGradient(context, paperRect, lightColor, self.highlighted ? highlightColor : darkColor);
    drawGlossAndGradient(context, paperRect, self.highlighted ? highlightColor : lightColor, darkColor);



    // Add white 1 px stroke
    CGRect strokeRect = paperRect;
    strokeRect.size.height -= 1;
    strokeRect = rectFor1PxStroke(strokeRect);

    CGContextSetStrokeColorWithColor(context, highlightColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokeRect(context, strokeRect);

    strokeRect.origin.x += 1;
    strokeRect.size.width -= 2;
    strokeRect.origin.y += 1;
    strokeRect.size.height -= 2;
    //strokeRect = rectFor1PxStroke(strokeRect);

    CGContextSetStrokeColorWithColor(context, darkColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokeRect(context, strokeRect);


    [self addSubview: titleLabel];
    [self addSubview: imageView];


}


- (void) dealloc {
    [_lightColor release];
    [_highlightColor release];
    [_darkColor release];
    [_separatorColor release];
    [_color release];
	
    [titleLabel release];
    [text release];
    [imageView release];
    [super dealloc];
}



@end