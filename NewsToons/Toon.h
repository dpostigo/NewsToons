#import <Foundation/Foundation.h>
#import "YoutubeView.h"

@interface Toon : NSObject <NSCoding, NSXMLParserDelegate> {

    BOOL isFavorite;
    BOOL isBest;
    BOOL needsYoutubeInfo;
    NSString *title;
    NSString *date;
    NSString *nid;
    NSString *link;
    NSString *moreInfo;
    NSMutableArray *moreInfoLinks;
    NSString *descriptionText;
    NSString *youtubeString;
    NSURL *youtubeThumbnail;
    NSMutableArray *categories;
    NSMutableArray *tags;
    UIWebView *infoView;
    YoutubeView *videoView;
    YoutubeView *padvideoView;
    NSDate *dateObject;
    NSMutableArray *relatedToons;
    NSString *youtubeId;
    NSInteger emailCount;
    NSInteger viewCount;
    CGFloat rating;
    NSInteger likeCount;
    NSString *youtubeFeed;
    NSDate *youtubeDate;
    NSDate *drupalDate;
}

@property(nonatomic) BOOL isFavorite;
@property(nonatomic) BOOL needsYoutubeInfo;
@property(nonatomic) BOOL isBest;
@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *nid;
@property(nonatomic, retain) NSString *date;
@property(nonatomic, retain) NSString *link;
@property(nonatomic, retain) NSString *moreInfo;
@property(nonatomic, retain) NSMutableArray *moreInfoLinks;
@property(nonatomic, retain) NSString *descriptionText;
@property(nonatomic, retain) NSMutableArray *relatedToons;
@property(nonatomic, retain) NSMutableArray *categories;
@property(nonatomic, retain) NSMutableArray *tags;
@property(nonatomic, retain) NSURL *youtubeThumbnail;
@property(nonatomic, retain) NSString *youtubeString;
@property(nonatomic, retain) YoutubeView *videoView;
@property(nonatomic, retain) YoutubeView *padvideoView;
@property(nonatomic, retain) UIWebView *infoView;
@property(nonatomic, retain) NSString *youtubeId;
@property(nonatomic, assign) NSInteger emailCount;
@property(nonatomic, assign) NSInteger viewCount;
@property(nonatomic, assign) NSInteger likeCount;
@property(nonatomic) CGFloat rating;
@property(nonatomic, retain) NSDate *youtubeDate;
@property(nonatomic, retain) NSDate *drupalDate;
@property(nonatomic, retain) NSDate *dateObject;
- (NSString *) ratingString;
- (void) setYoutubeValues;
- (NSString *) youtubeFeed;
- (void) loadYoutubeView;
- (void) removeDuplicateLinks;
- (NSDictionary *) toDictionary;
- (id) JSON;
- (NSDate *) dateObject;
- (NSString *) viewCountString;
- (void) fetchYoutubeInfo;

@end
