//
//  BadgeView.h
//  
//  Created by Dani Postigo on 3/26/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import <CoreGraphics/CoreGraphics.h>
#import "BadgeView.h"
#import "UIView+Addons.h"


@implementation BadgeView {
    CGRect _frame;
}

@synthesize badgeColor;
@synthesize badgeFont;
@synthesize text;


- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame: frame];
    if ( self ) {
        _frame = frame;
        self.backgroundColor = [UIColor clearColor];
        self.badgeColor = [UIColor blackColor];
        self.badgeFont = [UIFont boldSystemFontOfSize: 11.0];
        self.text = @"";
    }

    return self;

}

- (void) setText: (NSString *) aText {
    if ( text != aText ) {
        [aText retain];
        [text release];
        text = aText;
    }
    [self setNeedsDisplay];

}


- (void) setBadgeColor: (UIColor *) aColor {
    if ( badgeColor != aColor ) {
        [aColor retain];
        [badgeColor release];
        badgeColor = aColor;
    }

}

- (void) setBadgeFont: (UIFont *) aFont {
    if ( badgeFont != aFont ) {
        [aFont retain];
        [badgeFont release];
        badgeFont = aFont;
    }

}


- (CGRect) frame {
    return _frame;
}

- (void) setFrame: (CGRect) aFrame {

    _frame = CGRectMake(aFrame.origin.x, aFrame.origin.y, _frame.size.width, _frame.size.height);
    [super setFrame: _frame];
}


- (void) drawRect: (CGRect) rect {

    CGContextRef context = UIGraphicsGetCurrentContext();

    UIColor * currentBadgeColor = self.badgeColor;

    CGSize badgeTextSize = [self.text sizeWithFont: self.badgeFont];

    CGFloat badgeY = ( rect.size.height - badgeTextSize.height - 4 ) / 2;
    CGFloat badgeWidth = badgeTextSize.width + 14;
    CGFloat badgeHeight = badgeTextSize.height + 4;
    CGFloat badgeX = rect.size.width - badgeWidth;

    CGRect badgeRect = CGRectMake(badgeX, badgeY, badgeWidth, badgeHeight);

    badgeRect = CGRectMake(0, 0, badgeTextSize.width, badgeTextSize.height);
    badgeRect.size.width += 14;
    badgeRect.size.height += 4;
    badgeRect.origin.y = 0;

    CGRect badgeViewFrame = CGRectIntegral(badgeRect);

    _frame = CGRectMake(_frame.origin.x, _frame.origin.y, badgeRect.size.width, badgeViewFrame.size.height - 10);



    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, currentBadgeColor.CGColor);
    CGMutablePathRef path = CGPathCreateMutable();


    CGPathAddArc(path, NULL, badgeViewFrame.origin.x + badgeViewFrame.size.width - badgeViewFrame.size.height / 2, badgeViewFrame.origin.y + badgeViewFrame.size.height / 2, badgeViewFrame.size.height / 2, M_PI / 2, M_PI * 3 / 2, YES);
    CGPathAddArc(path, NULL, badgeViewFrame.origin.x + badgeViewFrame.size.height / 2, badgeViewFrame.origin.y + badgeViewFrame.size.height / 2, badgeViewFrame.size.height / 2, M_PI * 3 / 2, M_PI / 2, YES);

    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathFill);
    CFRelease(path);
    CGContextRestoreGState(context);

    CGContextSaveGState(context);
    //CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    [self.text drawInRect: CGRectInset(badgeViewFrame, 7, 2) withFont: self.badgeFont];
    CGContextRestoreGState(context);



}

- (void) dealloc {
    [text release];
    [badgeColor release];
    [badgeFont release];
    [super dealloc];
}


@end