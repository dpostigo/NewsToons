//
//  GradientUIView.m
//  CoolTable
//
//  Created by Ray Wenderlich on 9/29/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "GradientUIView.h"
#import "UIViewStyles.h"

@implementation GradientUIView

@synthesize style;
@synthesize padding;

@synthesize drawsBorder;
@synthesize drawsFill;
@synthesize drawsSeparator;

@synthesize borderColor;
@synthesize lightFillColor;
@synthesize darkFillColor;
@synthesize separatorColor;
@synthesize lightSeparatorColor;


- (id) initWithFrame: (CGRect) frame {
    if ( ( self = [super initWithFrame: frame] ) ) {
        padding = 20;

        drawsBorder = NO;
        drawsFill = NO;
        drawsSeparator = NO;

        self.separatorColor = [UIColor blackColor];
        style = UIViewStyleGradient;

    }
    return self;
}


#pragma mark Overwrite setters

- (void) setFrame: (CGRect) aFrame {
    aFrame = CGRectMake(aFrame.origin.x, aFrame.origin.y, aFrame.size.width, aFrame.size.height);
    [super setFrame: aFrame];
    [self setNeedsDisplay];
}

- (void) setLightFillColor: (UIColor *) color {
    [color retain];
    [lightFillColor release];
    lightFillColor = color;
    drawsFill = YES;
    [self setNeedsDisplay];
}

- (void) setDarkFillColor: (UIColor *) color {
    [color retain];
    [darkFillColor release];
    darkFillColor = color;
    drawsFill = YES;
    [self setNeedsDisplay];
}

- (void) setBorderColor: (UIColor *) color {
    [color retain];
    borderColor = color;
    drawsBorder = YES;
    [self setNeedsDisplay];
}

- (void) setLightSeparatorColor: (UIColor *) color {
    [color retain];
    lightSeparatorColor = color;
    drawsSeparator = YES;
    [self setNeedsDisplay];
}

- (void) setSeparatorColor: (UIColor *) color {
    [color retain];
    separatorColor = color;
    drawsSeparator = YES;
    [self setNeedsDisplay];
}


- (void) drawRect: (CGRect) rect {
    if ( style == UIViewStyleGradient )
        [self drawGradient];
    else if ( style == UIViewStyleGlossy )
        [self drawGlossy];


}

- (void) dealloc {
    [separatorColor release];
    [lightSeparatorColor release];
    [borderColor release];
    [lightFillColor release];
    [darkFillColor release];
    [super dealloc];
}


#pragma mark GlossyStyle


- (void) drawGlossy {
    CGFloat coloredBoxMargin = 0.0;
    //CGFloat coloredBoxHeight = 40.0;

    _coloredBoxRect = CGRectMake(coloredBoxMargin, coloredBoxMargin, self.bounds.size.width - coloredBoxMargin * 2, self.bounds.size.height - self.padding);

    CGFloat paperMargin = 9.0;
    _paperRect = CGRectMake(paperMargin,
            CGRectGetMaxY(_coloredBoxRect),
            self.bounds.size.width - paperMargin * 2,
            self.bounds.size.height - CGRectGetMaxY(_coloredBoxRect));

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextBeginPath(context);

    CGColorRef lightColorRef;
    CGColorRef darkColorRef;
    CGColorRef shadowColor;

    lightColorRef = lightFillColor.CGColor;
    darkColorRef = darkFillColor.CGColor;
    shadowColor = [UIColor colorWithRed: 0.2 green: 0.2 blue: 0.2 alpha: 0.5].CGColor;



    // Draw paper
    // CGContextSetFillColorWithColor(context, whiteColor);
    //CGContextFillRect(context, _paperRect);

    // Draw shadow
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 3.0, shadowColor);
    CGContextSetFillColorWithColor(context, lightColorRef);
    CGContextFillRect(context, _coloredBoxRect);
    CGContextRestoreGState(context);

    // Draw gloss and gradient
    drawGlossAndGradient(context, _coloredBoxRect, lightColorRef, darkColorRef);

    // Draw stroke
    CGContextSetStrokeColorWithColor(context, darkColorRef);
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokeRect(context, rectFor1PxStroke(_coloredBoxRect));
}



#pragma mark GradientStyle


- (void) drawGradient {

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect paperRect = self.bounds;

    if ( drawsFill ) [self drawGradientFill: context paperRect: paperRect];
    if ( drawsSeparator ) [self drawSeparator: context paperRect: paperRect];
    if ( drawsBorder ) [self drawBorder: context paperRect: paperRect];

}


- (void) drawGradientFill: (CGContextRef) context paperRect: (CGRect) paperRect {

    CGColorRef lightColorRef = lightFillColor.CGColor;
    CGColorRef darkColorRef = darkFillColor.CGColor;
    drawLinearGradient(context, paperRect, lightColorRef, darkColorRef);


}


- (void) drawBorder: (CGContextRef) context paperRect: (CGRect) paperRect {
    CGColorRef lightColorRef = lightFillColor.CGColor;
    CGRect strokeRect = paperRect;
    strokeRect.size.height -= 1;
    strokeRect = rectFor1PxStroke(strokeRect);
    CGContextSetStrokeColorWithColor(context, lightColorRef);
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokeRect(context, strokeRect);
}


- (void) drawSeparator: (CGContextRef) context paperRect: (CGRect) paperRect {
    CGColorRef separatorColorRef;
    separatorColorRef = separatorColor.CGColor;

    CGFloat yPos;
    CGPoint startPoint;
    CGPoint endPoint;

    yPos = paperRect.origin.y + paperRect.size.height - 2;
    startPoint = CGPointMake(paperRect.origin.x, yPos);
    endPoint = CGPointMake(paperRect.origin.x + paperRect.size.width - 1, yPos);
    draw1PxStroke(context, startPoint, endPoint, separatorColorRef);

    /*
    yPos = paperRect.origin.y + paperRect.size.height - 3;
    startPoint = CGPointMake(paperRect.origin.x, yPos);
    endPoint = CGPointMake(paperRect.origin.x + paperRect.size.width - 1, yPos);
    draw1PxStroke(context, startPoint, endPoint, separatorColorRef);
                                       */
    if ( lightSeparatorColor ) {
        separatorColorRef = lightSeparatorColor.CGColor;
        yPos = paperRect.origin.y + paperRect.size.height - 1;
        startPoint = CGPointMake(paperRect.origin.x, yPos);
        endPoint = CGPointMake(paperRect.origin.x + paperRect.size.width - 1, yPos);
        draw1PxStroke(context, startPoint, endPoint, separatorColorRef);
    }
}


@end
