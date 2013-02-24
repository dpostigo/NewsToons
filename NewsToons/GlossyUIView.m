//
//  ${FILENAME}
//  
//  Created by Dani Postigo on 3/22/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import <CoreGraphics/CoreGraphics.h>
#import "GlossyUIView.h"
#import "UIViewStyles.h"

@implementation GlossyUIView

@synthesize titleLabel = _titleLabel;


@synthesize highlightColor = _highlightColor;
@synthesize lightColor = _lightColor;
@synthesize darkColor = _darkColor;
@synthesize separatorColor = _separatorColor;
@synthesize color = _color;


- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame: frame];
    if ( self ) {
		
		
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.titleLabel = [[[UILabel alloc] init] autorelease];
        _titleLabel.textAlignment = UITextAlignmentCenter;
        _titleLabel.opaque = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _titleLabel.shadowOffset = CGSizeMake(0, -1);
        //[self addSubview:_titleLabel];


        self.lightColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
        self.darkColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0];
        self.separatorColor = [UIColor blackColor];
        self.highlightColor = [UIColor whiteColor];

        button = [[UIButton alloc] initWithFrame: frame];
        button.backgroundColor = [UIColor clearColor];
        button.showsTouchWhenHighlighted = YES;
        button.adjustsImageWhenHighlighted = YES;
        [button addTarget: self action: @selector(handleDown) forControlEvents: UIControlEventTouchDown];
        [button addTarget: self action: @selector(handleUp) forControlEvents: UIControlEventTouchCancel];

        [self addSubview: button];
    }

    return self;
}

- (void) handleDown {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);
    button.backgroundColor = [UIColor blueColor];
    button.alpha = 0.4;
}


- (void) handleUp {
      button.backgroundColor = [UIColor clearColor];
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


- (void) cornerRadius: (CGFloat *) r {


}

- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGColorRef highlightColor = _highlightColor.CGColor;
    CGColorRef lightColor = _lightColor.CGColor;
    CGColorRef darkColor = _darkColor.CGColor;
    //CGColorRef separatorColor = _separatorColor.CGColor;

    CGRect paperRect = self.bounds;

    /*
    // Fill with gradient
    drawLinearGradient(context, paperRect, lightColor, darkColor);

    // Add white 1 px stroke
    CGRect strokeRect = paperRect;
    strokeRect.size.height -= 1;
    strokeRect = rectFor1PxStroke(strokeRect);

    CGContextSetStrokeColorWithColor(context, highlightColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokeRect(context, strokeRect);

    // Add separator
    CGPoint startPoint = CGPointMake(paperRect.origin.x, paperRect.origin.y + paperRect.size.height - 1);
    CGPoint endPoint = CGPointMake(paperRect.origin.x + paperRect.size.width - 1, paperRect.origin.y + paperRect.size.height - 1);
    draw1PxStroke(context, startPoint, endPoint, separatorColor);

    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);

               */


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
    drawGlossAndGradient(context, paperRect, lightColor, darkColor);

    /*
    // Draw stroke
    CGContextSetStrokeColorWithColor(context, highlightColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokeRect(context, rectFor1PxStroke(_coloredBoxRect));

       */

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




}


- (void)dealloc {
    [_titleLabel release];
    _titleLabel = nil;
    [_lightColor release];
    _lightColor = nil;
    [_darkColor release];
    _darkColor = nil;
    [_separatorColor release];
    [_color release];
    [button release];
    [super dealloc];
}


@end