//
//  CheckFeedUpdates.h
//  
//  Created by Dani Postigo on 3/27/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "BasicXMLOperation.h"
#import "CheckFeedUpdates.h"

@implementation CheckFeedUpdates {
}

@synthesize dateString;
@synthesize flashEmbedCode;

- (void) dealloc {
    [dateString release];
    [flashEmbedCode release];
    [super dealloc];
}

- (void) initNodes {
    self.mainElement = @"item";
    self.nodes = [[[NSMutableArray alloc] init] autorelease];
    [nodes addObject: @"date"];
    [nodes addObject: @"FlashEmbedCode"];
}

- (void) main {
    self.feedURL = [NSURL URLWithString: TOON_FEED_URL];
    self.dateString = [NSMutableString string];
    self.flashEmbedCode = [NSMutableString string];

    [super main];
}

- (void) mainElementBeganParsing {
    [super mainElementBeganParsing];

    dateString.string = @"";
    flashEmbedCode.string = @"";
}

- (void) mainElementEndedParsing {
    [super mainElementEndedParsing];


    if (![dateString isEqualToString: @""] && ![flashEmbedCode isEqualToString: @""]) {

        [self checkForUpdate];
    }
}

- (void) elementBeganParsing: (NSString *) elementName {
    [super elementBeganParsing: elementName];
}

- (void) elementEndedParsing: (NSString *) elementName {
    [super elementEndedParsing: elementName];

    if ([elementName isEqualToString: @"date"]) {
        dateString.string = parsedData;
    }

    else if ([elementName isEqualToString: @"FlashEmbedCode"]) {
        flashEmbedCode.string = parsedData;
    }
}

- (void) checkForUpdate {

    NSLog(@"dateString = %@", dateString);
    NSLog(@"_model.lastDate = %@", _model.lastDate);
    _model.needsUpdate = [dateString isEqualToString: _model.lastDate] ? NO: YES;

    if (_model.needsUpdate) {
        NSLog(@"UPDATE NEEDED.");
    } else {
        NSLog(@"UPDATE NOT NEEDED.");
    }

    [xmlParser abortParsing];
}



@end