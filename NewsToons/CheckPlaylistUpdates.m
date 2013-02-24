//
//  CheckPlaylistUpdates.h
//  
//  Created by Dani Postigo on 6/21/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "CheckPlaylistUpdates.h"
#import "Model.h"


@implementation CheckPlaylistUpdates {
    NSXMLParser * _xmlParser;
    NSMutableString * _parsedData;
    BOOL _isParsing;
    Model * _model;
}

- (id) init {
    self = [super init];
    if ( self ) {
        _model = [Model sharedModel];
        NSData * data = [[[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: YOUTUBE_URL_PLAYLISTS]] autorelease];
        _xmlParser = [[NSXMLParser alloc] initWithData: data];
        _xmlParser.delegate = self;
    }
    return self;
}

- (void) main {

    NSLog(@"%s, Line %d", __PRETTY_FUNCTION__, __LINE__);
    _parsedData = [NSMutableString string];
    [_xmlParser parse];

    _parsedData = nil;
    [_xmlParser release];
}


#pragma mark NSXMLParserDelegate methods

- (void) parser: (NSXMLParser *) parser didStartElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName attributes: (NSDictionary *) attributeDict {

    BOOL containsNode = [self containsNode: elementName];

    if (containsNode) {
        _isParsing = YES;
        _parsedData.string = @"";
    }
}

- (void) parser: (NSXMLParser *) parser didEndElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName {

    NSString * parsed = [[[NSString alloc] initWithString: _parsedData] autorelease];

    if ([elementName isEqualToString: @"openSearch:totalResults"]){
        _model.shouldUpdatePlaylists = [parsed isEqualToString: _model.youtubeResultsCount] ? NO : YES;
        _model.youtubeResultsCount = parsed;
        [_xmlParser abortParsing];

    }
    _isParsing = NO;
}

- (void) parser: (NSXMLParser *) parser foundCharacters: (NSString *) string {
    if (_isParsing) [_parsedData appendString: string];
}


- (BOOL) containsNode: (NSString * ) elementName {
    return ([elementName isEqualToString: @"updated"] || [elementName isEqualToString: @"openSearch:totalResults"]);
}


@end