//
//  Created by dpostigo on 3/19/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


typedef enum {
    YoutubeViewModeDefault,
    YoutubeViewModeFramed
} YoutubeViewMode;




@interface YoutubeView : UIView <UIWebViewDelegate> {
    UIWebView * webview;
    NSString * toonYoutubeString;
    UIActivityIndicatorView * activityView;
    YoutubeViewMode viewMode;
    NSString * videoId;
}

@property ( nonatomic, retain ) UIWebView * webview;
@property ( nonatomic ) YoutubeViewMode viewMode;
@property ( nonatomic, retain ) NSString * videoId;


- (void) disableScrolling;
- (void) beginActivity;
- (void) endActivity;
- (void) removeActivityView;


- (void) loadVideo: (NSString *) anId;


@end