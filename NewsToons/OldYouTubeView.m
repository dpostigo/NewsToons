//
//  OldYouTubeView.m
//  NewsToons
//
//  Created by Daniela Postigo on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OldYouTubeView.h"

@implementation OldYouTubeView

@synthesize webView;
@synthesize htmlString;
@synthesize initCount;

#pragma mark -
#pragma mark Initialization

- (OldYouTubeView *)initWithStringAsURL:(NSString *)urlString frame:(CGRect)frame;
{
    if (self = [super initWithFrame:frame]) {
        self.initCount = 0;

        // Create webview with requested frame size
        self.webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease] ;
        [self addSubview: self.webView];
        
        urlString = [urlString stringByAppendingString:@"&ap=%2526fmt%3D22"];
        
        // HTML to embed YouTube video
        NSString *youTubeVideoHTML = @"<html><head>\
        <body style=\"margin:0; background:transparent\">\
        <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
        width=\"%0.0f\" height=\"%0.0f\"></embed>\
        </body></html>";
        
        // Populate HTML with the URL and requested frame size
        NSString *html = [NSString stringWithFormat:youTubeVideoHTML, urlString, frame.size.width, frame.size.height];
        
        // Load the html into the webview
		[self disableScrolling];
        self.webView.delegate = self;
        [self.webView loadHTMLString:html baseURL:nil];
    }
    
    return self;  
}

- (void) reloadWithYoutubeString:(NSString *)urlString {
    urlString = [urlString stringByAppendingString:@"&ap=%2526fmt%3D22"];
    
    // HTML to embed YouTube video
    NSString *youTubeVideoHTML = @"<html><head>\
    <body style=\"margin:0; background:transparent\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
    
    // Populate HTML with the URL and requested frame size
    NSString *html = [NSString stringWithFormat:youTubeVideoHTML, urlString, self.frame.size.width, self.frame.size.height];
    
    if(self.webView.isLoading){
        self.htmlString = html;
        
    }
    else {
        
        [self.webView loadHTMLString:html baseURL:nil];
    }
	
	[self disableScrolling];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)thisWebView {
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    initCount++;

    if(![self.htmlString isEqual:[NSNull null]]){
        if(![self.htmlString isEqualToString:@""]){
            if (initCount != 1) 
                [self.webView loadHTMLString:self.htmlString baseURL:nil];
            self.htmlString = @"";
        }
    }
        
    
}


- (void) disableScrolling; {
	
	UIScrollView* sv = nil;
	for (UIView* v in self.subviews){
		if([v isKindOfClass:[UIScrollView class] ]){
			sv = (UIScrollView*) v;
			sv.scrollEnabled = NO;
			sv.bounces = NO;
		}
	}
	
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc {
    webView.delegate = nil;
    [webView release];
    [super dealloc];
}

@end