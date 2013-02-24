//
//  Created by dpostigo on 3/19/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import "YoutubeView.h"
#import "UIView+Addons.h"
#import "UIImageView+WebCache.h"


@implementation YoutubeView


@synthesize webview;
@synthesize viewMode;
@synthesize videoId;


#define cornerRadiusValue 5

#define CHECK_SIMULATOR 0
#define VIDEO_URL @"http://www.youtube.com/watch?v=%@&ap=%%2526fmt%%3D22"
#define VIDEO_URL_6 @"http://www.youtube.com/v/%@"

#define EMBED_HTML @"<html><head>\
        <body style=\"margin:0; padding: 0; background:transparent\" >\
        <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
        width=\"%0.0f\" height=\"%0.0f\"></embed>\
        </body></html>"

#define IFRAME_HTML @"<html><head><body><iframe class=\"youtube-player\" type=\"text/html\" width=\"%0.0f\" height=\"%0.0f\" src=\"http://www.youtube.com/embed/%@\" frameborder=\"0\">\n </iframe></body></html>"



- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame: frame];
    if ( self ) {

        videoId = [[NSString alloc] initWithString: @""];
        self.viewMode = YoutubeViewModeDefault;
        self.webview = [[UIWebView alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview: self.webview];
        [self disableScrolling];
        self.webview.delegate = self;
    }

    return self;
}


- (void) loadVideo: (NSString *) anId {

    [anId retain];
    [videoId release];
    videoId = anId;


    if ( ! CHECK_SIMULATOR ) {




        NSString *videoURL;

        NSString *systemVersion = [UIDevice currentDevice].systemVersion;
        CGFloat systemFloat = [systemVersion floatValue];

        if (systemFloat >= 6.0) {
            NSLog(@"tube mode is IOS6");
            videoURL = [[[NSString alloc] initWithFormat: VIDEO_URL_6, videoId] autorelease];
        }
        else {
            videoURL = [[[NSString alloc] initWithFormat: VIDEO_URL, videoId] autorelease];
        }

        NSString * htmlString = [[[NSString alloc] initWithFormat: EMBED_HTML, videoURL, self.frame.size.width, self.frame.size.height] autorelease];
        NSLog(@"htmlString = %@", htmlString);

        [self.webview loadHTMLString: htmlString baseURL: nil];

    } else [self loadForSimulator];



}



- (void) loadForSimulator {

    if ( [[UIDevice currentDevice].name isEqualToString: @"iPhone Simulator"] ) {
        NSLog(@"Loading Simulator image.");
        UIImageView * imageView;
        imageView = [[[UIImageView alloc] initWithFrame: CGRectMake(0, 0, self.width, self.height)] autorelease];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = cornerRadiusValue;
        imageView.userInteractionEnabled = NO;

        [self addSubview: imageView];
        NSString * string = [NSString stringWithFormat: kThumbnailURL, videoId];
        [imageView setImageWithURL: [NSURL URLWithString: string]];


    } else {

        NSString *frameString = [[[NSString alloc] initWithFormat: IFRAME_HTML, self.frame.size.width, self.frame.size.height, videoId] autorelease];
        [self.webview loadHTMLString: frameString baseURL: nil];

    }
}



- (void) setFrame: (CGRect) aFrame {
    [super setFrame: aFrame];
    self.webview.frame = aFrame;
    if (videoId) [self loadVideo: videoId];
}


- (void) disableScrolling; {

    UIScrollView * sv = nil;
    for ( UIView * v in self.webview.subviews ) {
        if ( [v isKindOfClass: [UIScrollView class]] ) {
            sv = (UIScrollView *) v;
            sv.scrollEnabled = NO;
            sv.bounces = NO;
        }
        v.layer.cornerRadius = cornerRadiusValue;
    }

    for ( UIView * v in self.subviews ) {
        if ( [v isKindOfClass: [UIScrollView class]] ) {
            sv = (UIScrollView *) v;
            sv.scrollEnabled = NO;
            sv.bounces = NO;
        }
        v.layer.cornerRadius = cornerRadiusValue;
    }
}


- (void) dealloc {
    webview.delegate = nil, [webview release];
    //[activityView release];
    [videoId release];
    [super dealloc];
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
    activityView.layer.cornerRadius = cornerRadiusValue;
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