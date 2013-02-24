//
//  CCKeyValuePair.m
//  Cocoafish-ios-sdk
//
//  Created by Wei Kong on 2/8/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCKeyValuePair.h"
#import "NSString+HTML.h"
#import "YAJL/YAJL.h"

@interface CCKeyValuePair ()

@property (nonatomic, retain, readwrite) NSString *key;
@property (nonatomic, retain, readwrite) NSString *value;
@property (nonatomic, retain, readwrite) NSDictionary *valueDictionary;
@property (nonatomic, retain, readwrite) NSArray *valueArray;
@property (nonatomic, retain, readwrite) NSString *type;
@end

@implementation CCKeyValuePair
@synthesize key = _key;
@synthesize value = _value;
@synthesize valueDictionary = _valueDictionary;
@synthesize valueArray = _valueArray;
@synthesize type = _type;

-(id)initWithJsonResponse:(NSDictionary *)jsonResponse
{
	if ((self = [super initWithJsonResponse:jsonResponse])) {
		self.key = [jsonResponse objectForKey:CC_JSON_KEY];
        self.type = [jsonResponse objectForKey:@"type"];
        
		NSString *jsonValue = [jsonResponse objectForKey:CC_JSON_VALUE];	
        jsonValue = [jsonValue stringByDecodingHTMLEntities];
        id jsonObject = nil;
        if ([self.type isEqualToString:@"json"]) {
            @try {
                jsonObject = [jsonValue yajl_JSON];
            } @catch (NSException *e) {
                // not a json string
            }
            if ([jsonObject isKindOfClass:[NSDictionary class]]) {
                self.valueDictionary = (NSDictionary *)jsonObject;
            } else if ([jsonObject isKindOfClass:[NSArray class]]) {
                self.valueArray = (NSArray *)jsonObject;
            }
        } else {
            self.value = jsonValue;
        }
	}
	
	return self;
}

/*- (NSString *)description {
    return [NSString stringWithFormat:@"CCKeyValuePair\n\tkey: %@\n\tvalue: %@\n\t%@", 
            self.key, self.value, [super description]];
}*/

+(NSString *)modelName
{
    return @"keyvalue";
}

+(NSString *)jsonTag
{
    return @"keyvalues";
}

-(void)dealloc
{
	self.key = nil;
	self.value = nil;
    self.valueDictionary = nil;
    self.valueArray = nil;
    self.type = nil;
	[super dealloc];
}


@end
