//
// Created by dpostigo on 9/3/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicObject.h"

@implementation BasicObject {
}

- (NSArray *) allKeys {
    NSArray *array = [[[NSArray alloc] init] autorelease];
    return array;
}


+ (id) objectWithProperties: (NSDictionary *) properties {
    return [[[self alloc] initWithProperties: properties] autorelease];
}


- (id) initWithProperties: (NSDictionary *) properties {
    self = [self init];
    if (self) {
        for (NSString *propertyKey in [self allKeys]) {
            [self setValue: [self valueForKey: propertyKey]
                    forKey: propertyKey];
        }
        [self setValuesForKeysWithDictionary: properties];
    }
    return self;
}


- (NSString *) stringForKey: (NSString *) key inDictionary: (NSDictionary *) dict {
    NSString *string = [dict objectForKey: key];
    if (string == nil) string = [NSString stringWithFormat: @"%@", string];
    return string;
}


- (void) addObjectsFromKey: (NSString *) key toArray: (NSMutableArray *) array forDictionary: (NSDictionary *) dict {

    NSMutableArray *keyArray = [dict objectForKey: key];
    if (keyArray) {
        [array addObjectsFromArray: keyArray];
    }
}


- (void) addObjectsFromKey: (NSString *) key toArray: (NSMutableArray *) array forCoder: (NSCoder *) coder {

    NSMutableArray *keyArray = [coder decodeObjectForKey: key];
    if (keyArray) {
        [array addObjectsFromArray: keyArray];
    }
}

@end