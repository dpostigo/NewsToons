//
//  OldYouTubeView.h
//  NewsToons
//
//  Created by Daniela Postigo on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OldYouTubeView : UIView <UIWebViewDelegate> {
    UIWebView *webView;
    NSString *htmlString;
    CGFloat initCount;
    
    
}
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSString *htmlString;
@property (nonatomic) CGFloat initCount;

- (OldYouTubeView *)initWithStringAsURL:(NSString *)urlString frame:(CGRect)frame;
- (void) reloadWithYoutubeString:(NSString *)urlString;

- (void) disableScrolling;

@end