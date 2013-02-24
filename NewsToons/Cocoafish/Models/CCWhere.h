//
//  CCWhere.h
//  Demo
//
//  Created by Kalila on 11/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCWhere : NSObject {
@private
    NSMutableDictionary *_where;
}

-(void)fieldName:(NSString *)fieldName lessThan:(NSObject *)value;
-(void)fieldName:(NSString *)fieldName greaterThan:(NSObject *)value;
-(void)fieldName:(NSString *)fieldName equalTo:(NSObject *)value;
-(void)fieldName:(NSString *)fieldName notEqualTo:(NSObject *)value;
-(void)fieldName:(NSString *)fieldName lessThanEqualTo:(NSObject *)value;
-(void)fieldName:(NSString *)fieldName greaterThanEqualTo:(NSObject *)value;
-(void)fieldName:(NSString *)fieldName containedIn:(NSArray *)values;
-(void)fieldName:(NSString *)fieldName notContainedIn:(NSArray *)values;
-(void)fieldName:(NSString *)fieldName regex:(NSString *)value;
-(void)fieldName:(NSString *)fieldName nearLat:(double)latitude nearLng:(double)longitude;
-(void)fieldName:(NSString *)fieldName nearLat:(double)latitude nearLng:(double)longitude maxDistanceKm:(double)distanceKm;
-(void)fieldName:(NSString *)fieldName nearLat:(double)latitude nearLng:(double)longitude maxDistanceMi:(double)distanceMi;

@end
