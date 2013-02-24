//
// Created by dpostigo on 10/10/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


typedef enum {
    TubeURLModeDefault = 0,
    TubeURLModeOS6 = 1,
    TubeURLModeSimulator = 2,
    TubeURLModeFramed = 3
} TubeURLMode;


@interface TubeView : UIView <UIWebViewDelegate> {


    TubeURLMode tubeURLMode;

    CGFloat cornerRadius;
    BOOL scrollingDisabled;

    NSString *tubeId;
    UIWebView *webView;


    UIActivityIndicatorView * activityView;
}

@property(nonatomic, retain) UIWebView *webView;
@property(nonatomic, retain) NSString *tubeId;
@property(nonatomic) BOOL scrollingDisabled;
@property(nonatomic) CGFloat cornerRadius;
@property(nonatomic) TubeURLMode tubeURLMode;
- (id) initWithFrame: (CGRect) frame;
- (id) initWithFrame: (CGRect) frame tubeID: (NSString *) aTubeId;
- (void) load;

@end