//
//  PlaylistOperation.h
//  
//  Created by Dani Postigo on 3/30/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "ParsePlaylistToons.h"
#import "Model.h"
#import "VideoFeedOperation.h"
#import "NSString+Addons.h"
#import "NSMutableArray+Toon.h"

#define ytVideoId @"yt:videoid"

@implementation ParsePlaylistToons {
    Toon * currentToonObject;
}

@synthesize playlist;



- (void) main {

    NSLog(@"%s, %@", __PRETTY_FUNCTION__, playlist.title);

    parsedData = [NSMutableString string];
    [_xmlParser parse];

    parsedData = nil;
    _xmlParser.delegate = nil, [_xmlParser release];
    [nodes release];

}


- (void) parser: (NSXMLParser *) parser didStartElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName attributes: (NSDictionary *) attributeDict {

    if ( [elementName isEqualToString: @"entry"] ) {

        currentToonObject = [[Toon alloc] init];

    }

    else if ( [elementName isEqualToString: @"media:thumbnail"] ) {

        NSString * imageType = [attributeDict objectForKey: @"yt:name"];
        if ( imageType ) {
            if ( [imageType isEqualToString: @"hqdefault"] ) {
                NSString * thumbURL = [attributeDict objectForKey: @"url"];
                currentToonObject.youtubeThumbnail = [NSURL URLWithString: thumbURL];
            }
        }

    }

    else if ( [self.nodes containsObject: elementName] ) {
        [self startParsingData];
    }

}


- (void) finish {
    [[NSNotificationCenter defaultCenter] postNotificationName: singlePlaylistUpdated object: playlist];

}

- (NSMutableArray *) nodes {
    if ( !nodes ) {
        nodes = [[NSMutableArray alloc] init];
        [nodes addObject: @"media:description"];
        [nodes addObject: @"media:title"];
        [nodes addObject: ytVideoId];
        [nodes addObject: @"published"];
    }
    return nodes;
}


- (void) parser: (NSXMLParser *) parser didEndElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName {
    NSString * string = [[[NSString alloc] initWithString: parsedData] autorelease];


    if ( [elementName isEqualToString: @"feed"] ) {
        [self parseVideoFeeds];
    }

    else if ( [elementName isEqualToString: @"entry"] ) {

        if ( [_model.toonLibrary containsToon: currentToonObject] ) {
            Toon * libraryToon = [_model.toonLibrary toonFromTitle: currentToonObject.title];
            [playlist.toons addToon: libraryToon];

        } else {
            [playlist.toons addObject: currentToonObject];
        }


        [currentToonObject release], currentToonObject = nil;

    }
    else if ( [elementName isEqualToString: @"media:description"] ) {
        NSString * strippedString = [[string stripURLs: @"http://www.markfiore.com"] autorelease];
        currentToonObject.descriptionText = strippedString;
    }

    else if ( [elementName isEqualToString: ytVideoId] ) {
        NSString * videoId = [[[NSString alloc] initWithString: parsedData] autorelease];
        currentToonObject.youtubeId = videoId;
        NSLog(@"Added %@", currentToonObject.youtubeId);

    }  else if ( [elementName isEqualToString: @"published"]) {

        NSLog(@"%s", __PRETTY_FUNCTION__);
        NSLog(@"RED ALERT");
        NSLog(@"ParsePlaylistToons node for published");

        NSString * string = [[[NSString alloc] initWithString: parsedData] autorelease];
        string = [string substringToIndex: 10];

        NSString * dateString = [[[NSString alloc] initWithString: string] autorelease];
        NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
        formatter.dateFormat = @"YYYY-MM-dd";

        NSLog(@"dateString = %@", dateString);
        
        currentToonObject.youtubeDate = [formatter dateFromString: dateString];

    }
}


- (void) parseVideoFeeds {


    if ( [playlist.toons count] > 0) {

        NSMutableArray * operations = [[[NSMutableArray alloc] init] autorelease];

        [playlist.toons enumerateObjectsUsingBlock:^(Toon *toon, NSUInteger index, BOOL *stop) {
            //NSLog(@"Toon = %@", toon.title);
            NSString * feedURL = [[[NSString alloc] initWithFormat: @"%@%@?v=2", videoFeedURL, toon.youtubeId] autorelease];
            NSURL * url = [[[NSURL alloc] initWithString: feedURL] autorelease];


            VideoFeedOperation * operation = [[[VideoFeedOperation alloc] initWithFeedURL: url] autorelease];
            operation.toon = toon;
            [operations addObject: operation];

        }];

        [[NSOperationQueue currentQueue] addOperations: operations waitUntilFinished: YES];



    }





}

- (void) dealloc {
    [playlist release];
    [super dealloc];
}


@end