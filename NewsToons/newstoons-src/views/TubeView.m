//
// Created by dpostigo on 10/10/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import "TubeView.h"


@implementation TubeView {
}

@synthesize webView;
@synthesize tubeId;
@synthesize scrollingDisabled;
@synthesize cornerRadius;
@synthesize tubeURLMode;


#define EMBED_HTML @"<html><head>\
        <body style=\"margin:0; padding: 0; background:transparent\" >\
        <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
        width=\"%0.0f\" height=\"%0.0f\"></embed>\
        </body></html>"


#define IFRAME_HTML @"<html><head><body><iframe class=\"youtube-player\" type=\"text/html\" src=\"%@\" width=\"%0.0f\" height=\"%0.0f\" frameborder=\"0\">\n </iframe></body></html>"


#define TUBEURL_DEFAULT @"http://www.youtube.com/watch?v=%@&ap=%%2526fmt%%3D22"
#define TUBEURL_IOS6 @"http://www.youtube.com/v/%@"

- (void) dealloc {
    [webView release];
    [tubeId release];
    [super dealloc];
}


- (id) initWithFrame: (CGRect) frame {
    return [self initWithFrame: frame tubeID: nil];
}


- (id) initWithFrame: (CGRect) frame tubeID: (NSString *) aTubeId {
    self = [super initWithFrame: frame];
    if (self) {


        tubeId = [aTubeId retain];
        self.backgroundColor = [UIColor blackColor];
        self.webView = [[[UIWebView alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        self.webView.delegate = self;
        [self addSubview: self.webView];

        [self determineTubeURLMode];

        self.cornerRadius = 4.0;
        self.scrollingDisabled = YES;
    }

    return self;
}


- (void) load {

    if (tubeId != nil) {
        NSString *htmlString = [self getURL];
        //NSLog(@"htmlString = %@", htmlString);
        [webView loadHTMLString: htmlString baseURL: nil];
    }


}


- (NSString *) getURL {

    NSString *tubeURL = nil;
    NSString *htmlString = nil;

    switch (tubeURLMode) {

        case TubeURLModeOS6 :
            tubeURL = [NSString stringWithFormat: TUBEURL_IOS6, self.tubeId];
            break;

        case TubeURLModeSimulator :
            break;

        case TubeURLModeDefault :
        default :
            tubeURL = [NSString stringWithFormat: TUBEURL_DEFAULT, tubeId];
            break;
    }

    htmlString = [NSString stringWithFormat: EMBED_HTML, tubeURL, self.frame.size.width, self.frame.size.height];
    return htmlString;
}


- (void) determineTubeURLMode {

    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    CGFloat systemFloat = [systemVersion floatValue];

    if (systemFloat >= 6.0) {
        //NSLog(@"tube mode is IOS6");
        tubeURLMode = TubeURLModeOS6;
    }
    else {
        tubeURLMode = TubeURLModeDefault;
    }
}

#pragma mark Setters

- (void) setScrollingDisabled: (BOOL) scrollingDisabled1 {
    scrollingDisabled = scrollingDisabled1;

    if (scrollingDisabled) {

        UIScrollView *sv = nil;
        for (UIView *v in self.webView.subviews) {
            if ([v isKindOfClass: [UIScrollView class]]) {
                sv = (UIScrollView *) v;
                sv.scrollEnabled = NO;
                sv.bounces = NO;
                sv.backgroundColor = self.backgroundColor;
            }
        }

        for (UIView *v in self.subviews) {
            if ([v isKindOfClass: [UIScrollView class]]) {
                sv = (UIScrollView *) v;
                sv.scrollEnabled = NO;
                sv.bounces = NO;
                sv.backgroundColor = self.backgroundColor;
            }
        }
    }
}


- (void) setCornerRadius: (CGFloat) cornerRadius1 {
    cornerRadius = cornerRadius1;

    for (UIView *v in self.webView.subviews) v.layer.cornerRadius = cornerRadius;
    for (UIView *v in self.subviews) v.layer.cornerRadius = cornerRadius;
}


- (void) setFrame: (CGRect) aFrame {
    [super setFrame: aFrame];
    self.webView.frame = aFrame;
    if (tubeId) [self load];
}





#pragma mark UIWebviewDelegate methods



- (void) webView: (UIWebView *) webView didFailLoadWithError: (NSError *) error {


}

- (void) webViewDidFinishLoad: (UIWebView *) webView {
    if ( webView.isLoading ) return;
    else {

        self.layer.shouldRasterize = YES;
        // [self endActivity];

    }

}


- (void) beginActivity {
    activityView = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(0, 0, self.width, self.height)];
    activityView.backgroundColor = [UIColor blackColor];
    activityView.layer.cornerRadius = cornerRadius;
    [self addSubview: activityView];
    [activityView startAnimating];


}

- (void) endActivity {

    [UIView beginAnimations: @"activity" context: nil];
    [UIView setAnimationDuration: 1.0];
    [UIView setAnimationDidStopSelector: @selector(removeActivityView)];
    activityView.alpha = 0;
    [UIView commitAnimations];


}

- (void) removeActivityView {
    [activityView stopAnimating];
    [activityView release];
    activityView = nil;

}


@end