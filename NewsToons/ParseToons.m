//
//  ParseToons.h
//  
//  Created by Dani Postigo on 3/27/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "ParseToons.h"
#import "NSString+Addons.h"
#import "NSMutableArray+Toon.h"

#define itemNode @"item"
#define nidNode @"nid"
#define titleNode @"title"
#define dateNode @"date"
#define linkNode @"link"
#define tagNode @"name"
#define thumbnailNode @"thumbnail"
#define moreLinksNode @"moreInfoText"
#define descriptionNode @"metaDescription"
#define flashEmbedNode @"FlashEmbedCode"

#define YOUTUBE_URL1 @"youtube.com/v/"
#define YOUTUBE_URL2  @"youtube.com/embed/"
#define FEED_URL @"https://gdata.youtube.com/feeds/api/videos/%@?v=2"

@implementation ParseToons {
    BOOL shouldCount;
}

@synthesize addedToons;
@synthesize currentToonObject;
@synthesize allowsAbort;
@synthesize dateFormatter;

- (void) dealloc {
    youtubeFeed = nil;
    [addedToons release];
    [dateFormatter release];
    [currentToonObject release];
    [super dealloc];
}

- (void) initNodes {
    self.nodes = [[[NSMutableArray alloc] init] autorelease];
    [nodes addObject: nidNode];
    [nodes addObject: titleNode];
    [nodes addObject: dateNode];
    [nodes addObject: linkNode];
    [nodes addObject: tagNode];
    [nodes addObject: thumbnailNode];
    [nodes addObject: moreLinksNode];
    [nodes addObject: descriptionNode];
    [nodes addObject: flashEmbedNode];
}

- (id) init {
    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);

    NSInteger currentPageNo = [Model sharedModel].currentFeedPage;
    NSLog(@"currentPageNo = %i", currentPageNo);
    NSString *urlString = [NSString stringWithFormat: @"%@?page=%i", TOON_FEED_URL, currentPageNo];

    return [self initWithFeedURL: [NSURL URLWithString: urlString] shouldCount: YES];
}

- (id) initWithFeedURL: (NSURL *) aFeedURL {
    return [self initWithFeedURL: aFeedURL shouldCount: NO];
}

- (id) initWithFeedURL: (NSURL *) aFeedURL shouldCount: (BOOL) aCount {
    self = [super init];
    if (self) {
        shouldCount = aCount;
        feedURL = [aFeedURL retain];
        self.addedToons = [[[NSMutableArray alloc] init] autorelease];

        self.mainElement = @"item";

        self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        dateFormatter.dateFormat = @"MM/dd/yy";
    }

    return self;
}

- (void) main {

    if (_model.needsUpdate || shouldCount) {

        [super main];
        [self handlePageCounting];
        [_model archive];
    }

    if (_model.currentFeedPage == initialPageAmount) {
        NSLog(@"ParseToons: initialLoadReadyKey");
        [_model quickNoticeWithString: initialLoadReadyKey];
    } else {
        NSLog(@"ParseToons: toonsReadyKey");
        [_model quickNoticeWithString: toonsReadyKey];
    }

    [_model notifyDelegates: @selector(toonsDidLoad:) object: addedToons];
}

- (void) handlePageCounting {
    if ([addedToons count] > 0) {
        Toon *lastToon = [addedToons lastObject];
        Toon *firstToon = [addedToons objectAtIndex: 0];

        if (_model.currentFeedPage == 0) {
            _model.lastDate = [dateFormatter stringFromDate: firstToon.dateObject];
            NSLog(@"set _model.lastDate = %@", _model.lastDate);
            NSLog(@"firstToon = %@", firstToon.title);
        }

        if (shouldCount) {
            _model.currentFeedPage++;
        }
        if (shouldCount || _model.feedDate == nil) {
            _model.feedDate = lastToon.dateObject;
        }
    }

    NSLog(@"INCREMETED PAGE");
}

#pragma mark NSXMLParserDelegate -

- (void) mainElementBeganParsing {
    [super mainElementBeganParsing];
    self.currentToonObject = [[[Toon alloc] init] autorelease];
    youtubeFeed = nil;
}

- (void) mainElementEndedParsing {
    [super mainElementEndedParsing];

    totalToons++;

    if ([self validateString: currentToonObject.youtubeId]) {
        [self processValidToon];
    }

    currentToonObject = nil;
}

- (void) processValidToon {
    [addedToons addObject: currentToonObject];

    BOOL containsToon = [_model.toonLibrary containsToon: currentToonObject];
    Toon *libraryToon = [_model.toonLibrary toonFromTitle: currentToonObject.title];

    if (!containsToon) {
        [_model.toonLibrary addToon: currentToonObject];
        NSLog(@"Not in toon library.");
    }

    else if (libraryToon == nil) {
        [_model.toonLibrary addToon: currentToonObject];
        NSLog(@"Not in toon library.");
    }
    else {

        NSLog(@"Just modifying existing library toon. - %@", self.currentToonObject.title);
        libraryToon.dateObject = currentToonObject.dateObject;
        libraryToon.date = currentToonObject.date;
        libraryToon.nid = currentToonObject.nid;
        libraryToon.link = currentToonObject.link;
        libraryToon.moreInfoLinks = currentToonObject.moreInfoLinks;
        libraryToon.tags = currentToonObject.tags;
        libraryToon.descriptionText = currentToonObject.descriptionText;

        NSLog(@"libraryToon.emailCount = %i", libraryToon.emailCount);
        if (libraryToon.emailCount > 0) {
            libraryToon.youtubeId = currentToonObject.youtubeId;
            libraryToon.youtubeString = currentToonObject.youtubeString;
            libraryToon.youtubeThumbnail = currentToonObject.youtubeThumbnail;

            libraryToon.likeCount = currentToonObject.likeCount;
            libraryToon.rating = currentToonObject.rating;
            libraryToon.viewCount = currentToonObject.viewCount;

            [_model notifyDelegates: @selector(shouldSaveEmailedToons:) object: libraryToon];
        }
    }




    /*
    NSArray *array = [NSArray arrayWithObjects: @"Tradition", nil];
    if ([array containsObject: currentToonObject.title]) {
        NSLog(@"libraryToon = %@", libraryToon);
        NSLog(@"libraryToon.date = %@", libraryToon.date);
        NSLog(@"currentToonObject.date = %@", currentToonObject.date);
        [self compareToon: libraryToon];
    }
    */

}

- (void) compareToon: (Toon *) libraryToon {

    NSLog(@"BEGIN COMPARE");



    if (![currentToonObject.youtubeId isEqualToString: libraryToon.youtubeId]) {
        NSLog(@"%@ | %@", currentToonObject.youtubeId, libraryToon.youtubeId);
    }

    if (![currentToonObject.date isEqualToString: libraryToon.date]) {
        NSLog(@"%@ | %@", currentToonObject.date, libraryToon.date);
    }

    if (![currentToonObject.dateObject isEqual: libraryToon.dateObject]) {
        NSLog(@"%@ | %@", currentToonObject.dateObject, libraryToon.dateObject);
    }

    if (![currentToonObject.nid isEqual: libraryToon.nid]) {
        NSLog(@"%@ | %@", currentToonObject.nid, libraryToon.nid);
    }

    if (![currentToonObject.link isEqual: libraryToon.link]) {
        NSLog(@"%@ | %@", currentToonObject.link, libraryToon.link);
    }

    if (![currentToonObject.moreInfo isEqual: libraryToon.moreInfo]) {
        NSLog(@"%@ | %@", currentToonObject.moreInfo, libraryToon.moreInfo);
    }

    if (![currentToonObject.moreInfoLinks isEqual: libraryToon.moreInfoLinks]) {
        NSLog(@"%@ | %@", currentToonObject.moreInfoLinks, libraryToon.moreInfoLinks);
    }

    if (![currentToonObject.descriptionText isEqual: libraryToon.descriptionText]) {
        NSLog(@"%@ | %@", currentToonObject.descriptionText, libraryToon.descriptionText);
    }

    if (![currentToonObject.youtubeString isEqual: libraryToon.youtubeString]) {
        NSLog(@"%@ | %@", currentToonObject.youtubeString, libraryToon.youtubeString);
    }

    NSLog(@"%@ | %@", currentToonObject.youtubeThumbnail, libraryToon.youtubeThumbnail);

    NSLog(@"%@ | %@", currentToonObject.categories, libraryToon.categories);
    NSLog(@"%@ | %@", currentToonObject.tags, libraryToon.tags);

    NSLog(@"%d | %d", currentToonObject.isFavorite, libraryToon.isFavorite);
    NSLog(@"%d | %d", currentToonObject.isBest, libraryToon.isBest);

    NSLog(@"%i | %i", currentToonObject.viewCount, libraryToon.viewCount);
    NSLog(@"%i | %i", currentToonObject.emailCount, libraryToon.emailCount);
    NSLog(@"%f | %f", currentToonObject.rating, libraryToon.rating);
    NSLog(@"%i | %i", currentToonObject.likeCount, libraryToon.likeCount);



    /*


currentToonObject.youtubeId = libraryToon.youtubeId;
currentToonObject.categories = libraryToon.categories;
currentToonObject.descriptionText = libraryToon.descriptionText;
currentToonObject.emailCount = currentToonObject.emailCount;
currentToonObject.isFavorite = currentToonObject.isFavorite;
currentToonObject.isBest = libraryToon.isBest;
currentToonObject.likeCount = libraryToon.likeCount;
currentToonObject.rating = libraryToon.rating;
currentToonObject.nid = libraryToon.nid;
currentToonObject.youtubeThumbnail = libraryToon.youtubeThumbnail;
currentToonObject.tags = libraryToon.tags;
currentToonObject.viewCount = libraryToon.viewCount;

*/




}

- (void) elementBeganParsing: (NSString *) elementName {
    [super elementBeganParsing: elementName];
    if ([elementName isEqualToString: @"tags"]) {
        _parsingTags = YES;
    }
}

- (void) elementEndedParsing: (NSString *) elementName {
    [super elementEndedParsing: elementName];

    if ([elementName isEqualToString: @"rss"]) {
        currentToonObject = nil;
    }
    if ([elementName isEqualToString: titleNode]) {

        NSString *title = [[[NSString alloc] initWithString: parsedData] autorelease];
        self.currentToonObject.title = title;
    } else if ([elementName isEqualToString: nidNode]) {

        currentToonObject.nid = [[[NSString alloc] initWithString: parsedData] autorelease];
    } else if ([elementName isEqualToString: dateNode]) {

        //NSLog(@"DATE FOR %@", currentToonObject.title);
        //NSLog(@"parsedData = %@", parsedData);
        NSDate *date = [dateFormatter dateFromString: parsedData];

        currentToonObject.drupalDate = date;
    } else if ([elementName isEqualToString: linkNode]) {
        if (!self.currentToonObject.link) {
            self.currentToonObject.link = [[[NSString alloc] initWithString: parsedData] autorelease];
        }
    } else if ([elementName isEqualToString: descriptionNode]) {

        currentToonObject.descriptionText = [[[NSString alloc] initWithString: parsedData] autorelease];
    } else if ([elementName isEqualToString: @"moreInfoText"]) {

        [self handleLinks: parsedData];
    } else if ([elementName isEqualToString: @"tags"]) {

        _parsingTags = NO;
    } else if ([elementName isEqualToString: tagNode]) {

        if (_parsingTags) {

            [self handleTags];
        }
    } else if ([elementName isEqualToString: flashEmbedNode]) {

        NSString *parsedString = [[[NSString alloc] initWithString: parsedData] autorelease];
        NSString *youtubeID = [self findYoutubeInString: parsedString];

        if (youtubeID != nil) {
            [self handleYoutubeID: youtubeID];
        }

        else {

            NSLog(@"Not a valid FlashEmbed Node = %@", currentToonObject.title);
        }
    }
}

- (void) parser: (NSXMLParser *) parser didEndElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName {
    if (self.currentToonObject != nil) {
        [super parser: parser didEndElement: elementName namespaceURI: namespaceURI qualifiedName: qName];
    }
}

- (void) handleTags {
    NSString *tag = [[parsedData mutableCopy] autorelease];

    if (currentToonObject.tags == nil) {
        currentToonObject.tags = [[[NSMutableArray alloc] init] autorelease];
    }

    if ([tag isEqualToString: @"Best Of"]) {
        self.currentToonObject.isBest = YES;
    } else {
        [self.currentToonObject.tags addObject: tag];
    }
}

- (void) handleYoutubeID: (NSString *) youtubeID {

    self.currentToonObject.youtubeId = [[[NSString alloc] initWithString: youtubeID] autorelease];
    self.currentToonObject.youtubeString = [NSString stringWithFormat: @"http://www.youtube.com/watch?v=%@", self.currentToonObject.youtubeId];
    self.currentToonObject.youtubeThumbnail = [NSURL URLWithString: [NSString stringWithFormat: @"http://img.youtube.com/vi/%@/0.jpg", self.currentToonObject.youtubeId]];

    if (LOAD_YOUTUBE_ON_LAUNCH) {

        NSString *youtubeFeedURL = [[[NSString alloc] initWithFormat: FEED_URL, currentToonObject.youtubeId] autorelease];
        NSString *feedString = [[[NSString alloc] initWithContentsOfURL: [NSURL URLWithString: youtubeFeedURL] encoding: NSUTF8StringEncoding error: nil] autorelease];
        NSString *likesString = [feedString getValueBetween: @"numLikes='" and: @"'"];
        NSString *ratingString = [feedString getValueBetween: @"rating average='" and: @"'"];
        NSString *viewString = [feedString getValueBetween: @"viewCount='" and: @"'"];

        self.currentToonObject.likeCount = [likesString integerValue];
        self.currentToonObject.rating = [ratingString floatValue];
        self.currentToonObject.viewCount = [viewString integerValue];
    }
}

- (void) handleLinks: (NSString *) string {

    @autoreleasepool {

        NSMutableString *newString = [[[NSMutableString alloc] initWithString: string] autorelease];

        [newString replaceOccurrencesOfString: @"<p>" withString: @"" options: NSCaseInsensitiveSearch range: NSMakeRange(0, [newString length])];
        [newString replaceOccurrencesOfString: @"</p>" withString: @"" options: NSCaseInsensitiveSearch range: NSMakeRange(0, [newString length])];

        NSArray *links = [newString componentsSeparatedByString: @"http://"];
        links = [links filteredArrayUsingPredicate: [NSPredicate predicateWithFormat: @"length > 0"]];

        if (currentToonObject.moreInfoLinks == nil)
            currentToonObject.moreInfoLinks = [[[NSMutableArray alloc] init] autorelease];

        for (NSString *urlString in links) {
            NSString *link = [NSString stringWithFormat: @"http://%@", urlString];

            [currentToonObject.moreInfoLinks addObject: link];
        }
    }
}

- (NSString *) findYoutubeInString: (NSString *) parsedString {

    if ([parsedData containsString: @"brightcove"])
        return nil;

    parsedString = [parsedString stringByReplacingOccurrencesOfString: @"&lt;" withString: @"<"];

    NSScanner *scanner = [NSScanner scannerWithString: parsedString];
    NSString *youtubeURL = nil;
    NSRange range = [parsedString rangeOfString: YOUTUBE_URL1];
    if (range.location != NSNotFound)
        youtubeURL = [NSString stringWithFormat: @"%@", YOUTUBE_URL1];
    else
        youtubeURL = [NSString stringWithFormat: @"%@", YOUTUBE_URL2];

    NSString *result = nil;
    if ([scanner scanUpToString: youtubeURL intoString: &result]) {
        [scanner scanUpToString: @"?" intoString: &result];

        if (result) {

            result = [result substringFromIndex: youtubeURL.length];

            NSRange range = [result rangeOfString: @"&"];
            if (range.location != NSNotFound)
                result = [result substringToIndex: range.location];

            range = [result rangeOfString: @"\""];

            if (range.location != NSNotFound)
                result = [result substringToIndex: range.location];
        }
    }

    if (result == nil) {
        return nil;
    }

    return [NSString stringWithFormat: @"%@", result];
}

- (BOOL) validateString: (NSString *) aString {
    if (aString != nil) {
        if ([aString length] > 0) {
            return YES;
        }
    }
    return NO;
}

@end