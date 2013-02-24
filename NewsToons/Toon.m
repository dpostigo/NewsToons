#import "Toon.h"
#import "NSString+Addons.h"
#import "NSDate+JSON.h"
#import "ToonCoder.h"

@interface Toon ()

- (void) formatDescription;

@end

@implementation Toon

@synthesize title;
@synthesize date;
@synthesize nid;
@synthesize link;

@synthesize moreInfo;
@synthesize moreInfoLinks;
@synthesize descriptionText;

@synthesize categories;
@synthesize tags;
@synthesize isFavorite;

@synthesize youtubeString;
@synthesize youtubeThumbnail;
@synthesize padvideoView;
@synthesize videoView;
@synthesize infoView;


@synthesize relatedToons;

@synthesize viewCount;
@synthesize emailCount;
@synthesize youtubeId;
@synthesize likeCount;
@synthesize needsYoutubeInfo;
@synthesize isBest;
@synthesize rating;
@synthesize youtubeDate;
@synthesize drupalDate;
@synthesize dateObject;

- (id) init {
    self = [super init];
    if ( self ) {

    }

    return self;
}

- (id) initWithCoder: (NSCoder *) decoder {

    self = [super init];
    if ( self ) {
        self.title = [decoder decodeObjectForKey: @"title"];

        self.dateObject = [decoder decodeObjectForKey: @"date"];
        self.nid = [decoder decodeObjectForKey: @"nid"];
        self.link = [decoder decodeObjectForKey: @"link"];

        self.descriptionText = [decoder decodeObjectForKey: @"descriptionText"];
        self.moreInfo = [decoder decodeObjectForKey: @"moreInfo"];
        self.moreInfoLinks = [decoder decodeObjectForKey: @"moreInfoLinks"];

        self.youtubeString = [decoder decodeObjectForKey: @"youtubeString"];
        self.youtubeId = [decoder decodeObjectForKey: @"youtubeId"];
        self.youtubeThumbnail = [NSURL URLWithString: [decoder decodeObjectForKey: @"youtubeThumbnail"]];

        self.categories = [decoder decodeObjectForKey: @"categories"];
        self.tags = [decoder decodeObjectForKey: @"tags"];

        self.isFavorite = [decoder decodeBoolForKey: @"isFavorite"];
        self.isBest = [decoder decodeBoolForKey: @"isBest"];

        self.viewCount = [decoder decodeIntegerForKey: @"viewCount"];
        self.emailCount = [decoder decodeIntegerForKey: @"emailCount"];
        self.rating = [decoder decodeFloatForKey: @"rating"];
        self.likeCount = [decoder decodeIntegerForKey: @"likeCount"];


        //[self loadYoutubeView];

        [self removeDuplicateLinks];
        [self formatDescription];
    }
    return self;

}


- (void) encodeWithCoder: (NSCoder *) encoder {

    [encoder encodeObject: self.title forKey: @"title"];
    [encoder encodeObject: self.dateObject forKey: @"date"];
    [encoder encodeObject: nid forKey: @"nid"];
    [encoder encodeObject: link forKey: @"link"];

    [encoder encodeObject: (moreInfo != nil ? moreInfo : @"") forKey: @"moreInfo"];
    [encoder encodeObject: moreInfoLinks forKey: @"moreInfoLinks"];
    [encoder encodeObject: descriptionText forKey: @"descriptionText"];

    [encoder encodeObject: self.youtubeString forKey: @"youtubeString"];
    [encoder encodeObject: self.youtubeId forKey: @"youtubeId"];
	[encoder encodeObject: [youtubeThumbnail absoluteString] forKey: @"youtubeThumbnail"];

    [encoder encodeObject: categories forKey: @"categories"];
    [encoder encodeObject: tags forKey: @"tags"];

    [encoder encodeBool: isFavorite forKey: @"isFavorite"];
    [encoder encodeBool: isBest forKey: @"isBest"];


    [encoder encodeInteger: self.viewCount forKey: @"viewCount"];
    [encoder encodeInteger: self.emailCount forKey: @"emailCount"];
    [encoder encodeFloat: self.rating forKey: @"rating"];
    [encoder encodeInteger: self.likeCount forKey: @"likeCount"];


}



- (NSDictionary *) toDictionary {

    NSMutableDictionary *dictionary = [[[NSMutableDictionary alloc] init] autorelease];


    [dictionary setObject: self.title forKey: @"title"];
    [dictionary setObject: self.dateObject forKey: @"date"];
    [dictionary setObject: nid forKey: @"nid"];
    [dictionary setObject: link forKey: @"link"];
    [dictionary setObject: (moreInfo != nil ? moreInfo : @"") forKey: @"moreInfo"];
    [dictionary setObject: [NSArray arrayWithArray: moreInfoLinks] forKey: @"moreInfoLinks"];
    [dictionary setObject: descriptionText forKey: @"descriptionText"];

    [dictionary setObject: self.youtubeString forKey: @"youtubeString"];
    [dictionary setObject: self.youtubeId forKey: @"youtubeId"];
    [dictionary setObject: [youtubeThumbnail absoluteString] forKey: @"youtubeThumbnail"];


    [dictionary setObject: [NSArray arrayWithArray: categories] forKey: @"categories"];
    [dictionary setObject: [NSArray arrayWithArray: tags] forKey: @"tags"];

    [dictionary setObject: [NSNumber numberWithBool: isFavorite] forKey: @"isFavorite"];
    [dictionary setObject: [NSNumber numberWithBool: isBest] forKey: @"isBest"];


    [dictionary setObject: [NSNumber numberWithInteger: self.viewCount] forKey: @"viewCount"];
    [dictionary setObject: [NSNumber numberWithInteger: self.emailCount] forKey: @"emailCount"];
    [dictionary setObject: [NSNumber numberWithFloat: self.rating] forKey: @"rating"];
    [dictionary setObject: [NSNumber numberWithInteger: self.likeCount] forKey: @"likeCount"];


    return [NSDictionary dictionaryWithDictionary: dictionary];

}


- (id) initWithDictionary: (NSDictionary * ) dictionary {
    self = [super init];
    if ( self ) {

    }

    return self;

}


- (id) JSON {

    return [self toDictionary];
}


- (NSDate *) dateObject {

    if (drupalDate != nil) return drupalDate;
    if (youtubeDate != nil) return youtubeDate;
    return dateObject;
}


/*
- (void) setDateObject: (NSDate *) d {
    if (dateObject != nil) {
        NSLog(@"RED ALERT REPLACING ALREADY STORED DATE");
        NSLog(@"dateObject = %@", dateObject);
        NSLog(@"new date = %@", d);
    }

    if ( d != dateObject ) {
        [d retain];
        [dateObject release];
        dateObject = d;


        NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
        formatter.dateFormat = @"MMMM d, yyyy";
        [date release];
        date = [[formatter stringFromDate: dateObject] retain];
    }
}
*/

- (NSString *) date {
    if (date == nil) {
        NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
        formatter.dateFormat = @"MMMM d, yyyy";
        date = [[formatter stringFromDate: self.dateObject] retain];
    }
    return date;
}



- (NSInteger) viewCount {


    if ( !viewCount ) {
        NSString * viewString = [self.youtubeFeed getValueBetween: @"viewCount='" and: @"'"];
        viewCount = [viewString integerValue];
    }
    return viewCount;
}

- (NSString *) viewCountString {

    NSNumberFormatter * formatter = [[[NSNumberFormatter alloc] init] autorelease];
    formatter.numberStyle = NSNumberFormatterBehaviorDefault;
    formatter.usesGroupingSeparator = YES;
    formatter.groupingSeparator = @",";
    formatter.groupingSize = 3;
    return [formatter stringFromNumber: [NSNumber numberWithInteger: viewCount]];


}


- (NSInteger) likeCount {
    if ( !likeCount ) {
        NSString * likesCountStr = [self.youtubeFeed getValueBetween: @"numLikes='" and: @"'"];
        likeCount = [likesCountStr integerValue];
    }
    return likeCount;
}


- (CGFloat) rating {

    if ( !rating ) {
        NSString * ratingString = [self.youtubeFeed getValueBetween: @"rating average='" and: @"'"];
        rating = [ratingString floatValue];

        rating = round(rating * 100) / 100;
    }
    return rating;
}

- (NSString *) ratingString {
    return [NSString stringWithFormat: @"%.1f", rating];
}


- (void) setYoutubeValues {
    NSInteger count = self.viewCount;
    CGFloat value = self.rating;
    count = self.likeCount;

}


- (NSString *) youtubeFeed {
    if ( !youtubeId )
        return @"";

    else if ( !youtubeFeed ) {
        NSString * urlString;
        NSURL * feedURL;

        urlString = [NSString stringWithFormat: @"https://gdata.youtube.com/feeds/api/videos/%@?v=2", self.youtubeId];
        feedURL = [NSURL URLWithString: urlString];
        youtubeFeed = [[NSString alloc] initWithContentsOfURL: feedURL encoding: NSUTF8StringEncoding error: nil];
    }
    return youtubeFeed;
}


- (void) loadYoutubeView {
    //CGRect videoFrame = CGRectMake(8, 10, 305, 127);
    //if ( IPAD ) videoFrame = CGRectMake(33, 0, 476, 356);

    //videoView = [[YoutubeUIView alloc] initWithFrame: videoFrame];
    //[videoView loadString: youtubeString];

}

- (void) dealloc {
    [videoView release];
    [moreInfoLinks release];
    [youtubeId release];
    [descriptionText release];
    [youtubeFeed release];
    [youtubeString release];
    [moreInfo release];
    [dateObject release];
    [date release];
    [title release];
    [nid release];
    [link release];
    [categories release];
    [tags release];
    [youtubeThumbnail release];
    [padvideoView release];
    [relatedToons release];
    [youtubeDate release];
    [drupalDate release];
    [super dealloc];
}


- (void) removeDuplicateLinks {

    NSArray * noDuplicates = [[NSSet setWithArray: moreInfoLinks] allObjects];

    self.moreInfoLinks = [[[NSMutableArray alloc] initWithArray: noDuplicates] autorelease];

}

- (void) formatDescription {

    NSString * newString = [descriptionText stringByReplacingOccurrencesOfString: @".com" withString: @""];
    [newString retain];
    [descriptionText release];
    descriptionText = newString;

}


- (void) fetchYoutubeInfo {
    /*

     NSString * urlString = [NSString stringWithFormat: @"%@%@?v=2", videoFeedURL, toon.youtubeId];
     NSURL * url = [NSURL URLWithString: urlString];
     NSData * data = [[[NSData alloc] initWithContentsOfURL: url] autorelease];

     NSXMLParser * parser = [[[NSXMLParser alloc] initWithData: data] autorelease];
     parser.delegate = self;
      */
}


- (NSString *) youtubeString {
    if ( !youtubeString && youtubeId ) {
        youtubeString = [[NSString stringWithFormat: @"http://www.youtube.com/watch?v=%@", youtubeId] retain];
    }

    return youtubeString;
}


@end
