//
//  JSONCoder.h
//  
//  Created by Dani Postigo on 6/8/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "ToonCoder.h"


@implementation ToonCoder {

}

@synthesize dictionary;

- (id) initWithDictionary: (NSDictionary *) aDictionary {
    self = [super init];
    if ( self ) {
        dictionary = [aDictionary retain];
    }

    return self;

}


- (void) dealloc {
    [dictionary release];
    [super dealloc];
}


- (BOOL) decodeBoolForKey: (NSString *) key {
    return (BOOL) [dictionary objectForKey: key];
}

- (NSInteger) decodeIntegerForKey: (NSString *) key {
    return [[dictionary valueForKey: key] integerValue];
}

- (float) decodeFloatForKey: (NSString *) key {
    return [[dictionary valueForKey: key] floatValue];
}

- (NSDate *) decodeDateForKey: (NSString *) key; {
    NSString * dateString =  [dictionary objectForKey: key];
    NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
    NSDate * date = [formatter dateFromString: dateString];
    return date;
}

- (id) decodeObjectForKey: (NSString *) key {
    if ( [key isEqualToString: @"date"] )
        return [self decodeDateForKey: key];

    return [dictionary objectForKey: key];
}



@end