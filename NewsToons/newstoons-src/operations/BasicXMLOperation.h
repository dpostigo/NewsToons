//
// Created by dpostigo on 9/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicOperation.h"

@interface BasicXMLOperation : BasicOperation <NSXMLParserDelegate> {


    BOOL isParsing;
    NSXMLParser *xmlParser;
    NSMutableString * parsedData;

    NSString *mainElement;
    NSMutableArray *nodes;

    NSURL *feedURL;
}

@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSString *mainElement;
@property(nonatomic, retain) NSMutableArray *nodes;
@property(nonatomic) BOOL isParsing;
@property(nonatomic, retain) NSMutableString *parsedData;
@property(nonatomic, retain) NSURL *feedURL;


- (void) initParser;
- (void) mainElementBeganParsing;
- (void) mainElementEndedParsing;
- (void) elementBeganParsing: (NSString *) elementName;
- (void) elementEndedParsing: (NSString *) elementName;
- (void) initNodes;
- (void) parser: (NSXMLParser *) parser didStartElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName attributes: (NSDictionary *) attributeDict;
- (void) parser: (NSXMLParser *) parser didEndElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName;
- (void) parser: (NSXMLParser *) parser foundCharacters: (NSString *) string;

@end