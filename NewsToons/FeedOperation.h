//
//  FeedOperation.h
//  
//  Created by Dani Postigo on 3/30/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import <Foundation/Foundation.h>

@class Model;


@protocol FeedOperationProtocol <NSXMLParserDelegate>


@optional
- (NSString *) rootNode;

@required
- (NSMutableArray *) nodes;
- (void) parser: (NSXMLParser *) parser didStartElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName attributes: (NSDictionary *) attributeDict;
- (void) parser: (NSXMLParser *) parser didEndElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName;


@end


@interface FeedOperation : NSOperation <NSXMLParserDelegate> {


    Model * _model;

    SEL modelSelector;
    NSXMLParser * _xmlParser;
    NSMutableString * parsedData;
    NSMutableArray * nodes;
    BOOL isParsing;

}

@property ( nonatomic ) SEL modelSelector;


- (id) initWithFeedURL: (NSURL *) aFeedURL;
- (void) finish;
- (Model *) model;
- (void) startParsingData;


@end