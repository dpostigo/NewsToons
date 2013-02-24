//
//  CCWhere.m
//  Demo
//
//  Created by Kalila on 11/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CCWhere.h"

@implementation CCWhere

-(id)init
{
    self = [super init];
    if (self) {
        _where = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

-(void)fieldName:(NSString *)fieldName lessThan:(NSObject *)value
{
    if (!([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSDate class]])) {
        [NSException raise:@"Invalid Type" format:@"value must be type of NSString, NSNumber or NSDate"];
        
    }
    [_where setObject:[NSDictionary dictionaryWithObjectsAndKeys:value, @"$lt",nil] forKey:fieldName];
}

-(void)fieldName:(NSString *)fieldName greaterThan:(NSObject *)value
{
    if (!([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSDate class]])) {
        [NSException raise:@"Invalid Type" format:@"value must be type of NSString, NSNumber or NSDate"];
        
    }
    [_where setObject:[NSDictionary dictionaryWithObjectsAndKeys:value, @"$gt",nil] forKey:fieldName];
    
}

-(void)fieldName:(NSString *)fieldName equalTo:(NSObject *)value
{
    if (!([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSDate class]])) {
        [NSException raise:@"Invalid Type" format:@"value must be type of NSString, NSNumber or NSDate"];
        
    }
    [_where setObject:value forKey:fieldName];
}

-(void)fieldName:(NSString *)fieldName notEqualTo:(NSObject *)value
{
    if (!([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSDate class]])) {
        [NSException raise:@"Invalid Type" format:@"value must be type of NSString, NSNumber or NSDate"];
        
    }
    [_where setObject:[NSDictionary dictionaryWithObjectsAndKeys:value, @"$ne",nil] forKey:fieldName];
}

-(void)fieldName:(NSString *)fieldName lessThanEqualTo:(NSObject *)value
{
    if (!([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSDate class]])) {
        [NSException raise:@"Invalid Type" format:@"value must be type of NSString, NSNumber or NSDate"];
        
    }
    [_where setObject:[NSDictionary dictionaryWithObjectsAndKeys:value, @"$lte", nil] forKey:fieldName];
}

-(void)fieldName:(NSString *)fieldName greaterThanEqualTo:(NSObject *)value
{
    if (!([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSDate class]])) {
        [NSException raise:@"Invalid Type" format:@"value must be type of NSString, NSNumber or NSDate"];
        
    }
    [_where setObject:[NSDictionary dictionaryWithObjectsAndKeys:value, @"$gte", nil] forKey:fieldName];
}

-(void)fieldName:(NSString *)fieldName containedIn:(NSArray *)values
{
    [_where setObject:[NSDictionary dictionaryWithObjectsAndKeys:values, @"$in" ,nil] forKey:fieldName];
}

-(void)fieldName:(NSString *)fieldName notContainedIn:(NSArray *)values
{
    [_where setObject:[NSDictionary dictionaryWithObjectsAndKeys:values, @"$nin" ,nil] forKey:fieldName];

}

-(void)fieldName:(NSString *)fieldName regex:(NSString *)value
{
    [_where setObject:[NSDictionary dictionaryWithObjectsAndKeys:value, @"$regex", nil] forKey:fieldName];
    
}

-(void)fieldName:(NSString *)fieldName nearLat:(double)latitude nearLng:(double)longitude
{
    if (latitude > 90 || latitude < -90 || longitude > 180 || longitude < -180) {
        [NSException raise:@"Invalid Value" format:@"longitude : [-180, 180), latitude : [-90, 90]"];
    }
    [_where setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:[NSNumber numberWithDouble:longitude], [NSNumber numberWithDouble:latitude], nil], @"$nearSphere", nil] forKey:fieldName];
}

-(void)fieldName:(NSString *)fieldName nearLat:(double)latitude nearLng:(double)longitude maxDistanceKm:(double)distanceKm
{
    if (latitude > 90 || latitude < -90 || longitude > 180 || longitude < -180) {
        [NSException raise:@"Invalid Value" format:@"longitude : [-180, 180), latitude : [-90, 90]"];
    }
    if (distanceKm <= 0) {
        [NSException raise:@"Invalid Value" format:@"distance > 0"];
    }
    NSNumber *distance =[NSNumber numberWithDouble:distanceKm / 6371];
    [_where setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:[NSNumber numberWithDouble:longitude], [NSNumber numberWithDouble:latitude], nil], @"$nearSphere", distance, @"$maxDistance", nil] forKey:fieldName];
}

-(void)fieldName:(NSString *)fieldName nearLat:(double)latitude nearLng:(double)longitude maxDistanceMi:(double)distanceMi
{
    if (latitude > 90 || latitude < -90 || longitude > 180 || longitude < -180) {
        [NSException raise:@"Invalid Value" format:@"longitude : [-180, 180), latitude : [-90, 90]"];
    }
    if (distanceMi <= 0) {
        [NSException raise:@"Invalid Value" format:@"distance > 0"];
    }
    NSNumber *distance =[NSNumber numberWithDouble:distanceMi / 3959];
    [_where setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:[NSNumber numberWithDouble:longitude], [NSNumber numberWithDouble:latitude], nil], @"$nearSphere", distance, @"$maxDistance", nil] forKey:fieldName];
}

// support yajl_JSONString
- (id)JSON {
    return _where;
}

-(void)dealloc
{
    [_where release];
    [super dealloc];
}

@end
