//
//  CCKeyValuePair.h
//  Cocoafish-ios-sdk
//
//  Created by Wei Kong on 2/8/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCObject.h"

@interface CCKeyValuePair : CCObject {
	
	NSString *_key;
	NSString *_value;
    NSDictionary *_valueDictionary; // value can be a dictionary
    NSArray *_valueArray; // value can be an array
    NSString *_type; // type can be string or json, if it is json, we will fill the valueDictionary or valueArray field
}

@property (nonatomic, retain, readonly) NSString *key;
@property (nonatomic, retain, readonly) NSString *value;
@property (nonatomic, retain, readonly) NSDictionary *valueDictionary;
@property (nonatomic, retain, readonly) NSArray *valueArray;
@property (nonatomic, retain, readonly) NSString *type;


@end
