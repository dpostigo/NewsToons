//
// Created by dpostigo on 9/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicXMLOperation.h"
#import "NSMutableArray+Toon.h"

@implementation BasicXMLOperation {
}

@synthesize xmlParser;
@synthesize mainElement;
@synthesize nodes;
@synthesize isParsing;
@synthesize parsedData;
@synthesize feedURL;


- (void) dealloc {
    xmlParser.delegate = nil;
    [xmlParser release];
    [mainElement release];
    [nodes release];
    [parsedData release];
    [feedURL release];
    [super dealloc];
}


- (void) main {
    [super main];
    [self initParser];
}



- (void) initParser {
    [self initNodes];
    self.parsedData = [NSMutableString string];

    NSData *data = [[[NSData alloc] initWithContentsOfURL: feedURL] autorelease];

    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];

    if (data) {
        self.xmlParser = [[[NSXMLParser alloc] initWithData: data] autorelease];
        xmlParser.delegate = self;

        @autoreleasepool {
            [xmlParser parse];
        }
    }


}

- (void) mainElementBeganParsing {


}


- (void) mainElementEndedParsing {
}


- (void) elementBeganParsing: (NSString *) elementName {
}


- (void) elementEndedParsing: (NSString *) elementName; {
}


- (void) initNodes {

}

#pragma mark NSXMLParser -



- (void) parser: (NSXMLParser *) parser didStartElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName attributes: (NSDictionary *) attributeDict {

    if ([elementName isEqualToString: mainElement]) {
        [self mainElementBeganParsing];
    }

    else if ([nodes containsObject: elementName]) {
        isParsing = YES;
        parsedData.string = @"";
    }
    else {

        [self elementBeganParsing: elementName];
    }
}


- (void) parser: (NSXMLParser *) parser didEndElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName {
    if ([elementName isEqualToString: mainElement]) {
        [self mainElementEndedParsing];
    }

    else {
        [self elementEndedParsing: elementName];
    }

    isParsing = NO;
}


- (void) parser: (NSXMLParser *) parser foundCharacters: (NSString *) string {
    if (isParsing) [parsedData appendString: string];
}


- (void) parser: (NSXMLParser *) parser parseErrorOccurred: (NSError *) parseError {
    NSLog(@"%@ - %s", @"ParseToons", sel_getName(_cmd));
}

@end