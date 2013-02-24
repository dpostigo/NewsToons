//
//  ParseToons.h
//  
//  Created by Dani Postigo on 3/27/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import <Foundation/Foundation.h>
#import "Toon.h"
#import "Model.h"
#import "BasicOperation.h"
#import "BasicXMLOperation.h"

@interface ParseToons : BasicXMLOperation <NSXMLParserDelegate> {

    id delegate;

    Toon *currentToonObject;
    NSMutableArray *addedToons;
    BOOL _parsingTags;

    BOOL allowsAbort;
    NSUInteger totalToons;
    NSString *youtubeFeed;
    NSDateFormatter *dateFormatter;
}

@property(nonatomic, assign) id delegate;
@property(nonatomic) BOOL allowsAbort;
@property(nonatomic, retain) Toon *currentToonObject;
@property(nonatomic, retain) NSMutableArray *addedToons;
@property(nonatomic, retain) NSDateFormatter *dateFormatter;
- (id) init;
- (id) initWithFeedURL: (NSURL *) aFeedURL;

@end