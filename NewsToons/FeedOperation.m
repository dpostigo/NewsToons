//
//  FeedOperation.h
//  
//  Created by Dani Postigo on 3/30/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "FeedOperation.h"
#import "Model.h"


@implementation FeedOperation

@synthesize modelSelector;


- (id) initWithFeedURL: (NSURL *) feedURL {
    self = [super init];
    if ( self ) {

        [feedURL retain];
        NSData * data = [[[NSData alloc] initWithContentsOfURL: feedURL] autorelease];
        [feedURL release];



        _xmlParser = [[NSXMLParser alloc] initWithData: data];
        _xmlParser.delegate = self;


        _model = [Model sharedModel];

    }

    return self;
}

- (void) dealloc {
    [super dealloc];
}

- (void) main {


    parsedData = [NSMutableString string];
    [_xmlParser parse];

    parsedData = nil;
	
	_xmlParser.delegate = nil;
    [_xmlParser release];
    [nodes release];

    if (modelSelector) [[Model sharedModel] performSelectorOnMainThread: modelSelector withObject: nil waitUntilDone: NO];
    [self finish];

}

- (void) finish; {
}

- (Model *) model {
    return [Model sharedModel];
}


- (void) startParsingData {

    isParsing = YES;
    parsedData.string = @"";
}




#pragma mark NSXMLParserDelegate methods


- (void) parser: (NSXMLParser *) parser foundCharacters: (NSString *) string {
    if ( isParsing ) {
        [parsedData appendString: string];
    }
}


@end