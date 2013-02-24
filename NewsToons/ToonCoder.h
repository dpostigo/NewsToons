//
//  JSONCoder.h
//  
//  Created by Dani Postigo on 6/8/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import <Foundation/Foundation.h>


@interface ToonCoder : NSCoder {

    NSDictionary *dictionary;
}

@property ( nonatomic, retain ) NSDictionary * dictionary;
- (id) initWithDictionary: (NSDictionary *) aDictionary;
- (NSDate *) decodeDateForKey: (NSString *) key;
- (id) decodeObjectForKey: (NSString *) key;


@end