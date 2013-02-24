//
//  VideoFeedOperation.h
//  
//  Created by Dani Postigo on 4/9/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "VideoFeedOperation.h"
#import "Toon.h"
#import "NSString+Addons.h"


@implementation VideoFeedOperation

@synthesize toon;
@synthesize dateFormatter;


- (NSMutableArray *) nodes {
    if ( ! nodes ) {
        nodes = [[NSMutableArray alloc] init];
        [nodes addObject: @"media:description"];
        [nodes addObject: @"media:title"];
        [nodes addObject: @"published"];
    }
    return nodes;
}


- (void) main {


    self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.dateFormat = @"YYYY-MM-dd";

    [super main];
}


- (void) parser: (NSXMLParser *) parser didStartElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName attributes: (NSDictionary *) attributeDict {


    //NSLog(@"element name = %@", elementName);

    if ( [elementName isEqualToString: @"media:thumbnail"]) {
        NSString * attribute = [attributeDict objectForKey: @"yt:name"];
        if ( [attribute isEqualToString: @"hqdefault"] ) {
            attribute =  [attributeDict objectForKey: @"url"];
            toon.youtubeThumbnail = [NSURL URLWithString: attribute];
        }

    }

    else if ( [elementName isEqualToString: @"gd:rating"]) {
        NSString * attribute = [attributeDict objectForKey: @"average"];
        toon.rating = [attribute floatValue];
    }
    else if ( [elementName isEqualToString: @"yt:statistics"]) {
        NSString * attribute = [attributeDict objectForKey: @"viewCount"];
        toon.viewCount = [attribute integerValue];
    }
    else if ( [elementName isEqualToString: @"yt:rating"]) {
        NSString * attribute = [attributeDict objectForKey: @"numLikes"];
        toon.likeCount = [attribute integerValue];
    }

    else if ( [self.nodes containsObject: elementName] ) {
        [self startParsingData];
    }


}

- (void) parser: (NSXMLParser *) parser didEndElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName {
    NSString * string = [[[NSString alloc] initWithString: parsedData] autorelease];

    if ( [elementName isEqualToString: @"media:title"]) {
        toon.title = string;
        NSLog(@"parsing %@", toon.title);
    }
    else if ( [elementName isEqualToString: @"media:description"]) {
        NSString * strippedString = [[string stripURLs: @"http://www.markfiore.com"] autorelease];
        toon.descriptionText = strippedString;
    }
    else if ( [elementName isEqualToString: @"published"]) {




        NSString * dateString = [[[NSString alloc] initWithString: string] autorelease];
        string = [string substringToIndex: 10];

        NSLog(@"dateString = %@", dateString);
        toon.youtubeDate = [dateFormatter dateFromString: dateString];
    }
}


- (void) dealloc {
    [toon release];
    [dateFormatter release];
    [super dealloc];
}


@end