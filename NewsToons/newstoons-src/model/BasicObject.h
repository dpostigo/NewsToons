//
// Created by dpostigo on 9/3/12.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import <Foundation/Foundation.h>

@interface BasicObject : NSObject





- (NSArray *) allKeys;
+ (id) objectWithProperties: (NSDictionary *) properties;
- (id) initWithProperties: (NSDictionary *) properties;
- (NSString *) stringForKey: (NSString *) key inDictionary: (NSDictionary *) dict;

- (void) addObjectsFromKey: (NSString *) key toArray: (NSMutableArray *) array forDictionary: (NSDictionary *) dict;

- (void) addObjectsFromKey: (NSString *) key toArray: (NSMutableArray *) array forCoder: (NSCoder *) coder;






@end