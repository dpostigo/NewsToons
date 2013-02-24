//
//  CCObject.m
//  Demo
//
//  Created by Wei Kong on 12/15/10.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCObject.h"
#import "Cocoafish.h"

@interface CCObject()
@property (nonatomic, retain, readwrite) NSString *objectId;
@property (nonatomic, retain, readwrite) NSDate *createdAt;
@property (nonatomic, retain, readwrite) NSDate *updatedAt;
@property (nonatomic, retain, readwrite) NSArray *tags;
@property (nonatomic, retain, readwrite) NSDictionary *customFields;
@end


@implementation CCObject
@synthesize objectId = _objectId;
@synthesize createdAt = _createdAt;
@synthesize updatedAt = _updatedAt;
@synthesize tags = _tags;
@synthesize customFields = _customFields;
@synthesize etag = _etag;
@synthesize lastModified = _lastModified;

-(id)initWithJsonResponse:(NSDictionary *)jsonResponse
{
	if (jsonResponse == nil) {
        [self release];
		return nil;
	}
	self.objectId = [jsonResponse objectForKey:CC_JSON_OBJECT_ID];
	if (_objectId) {
		self = [super init];
	}
	
	
	NSString *dateString = [jsonResponse objectForKey:CC_JSON_CREATED_AT];
	if (dateString) {
		self.createdAt = [[[Cocoafish defaultCocoafish] jsonDateFormatter] dateFromString:dateString];
	}
	
	dateString = [jsonResponse objectForKey:CC_JSON_UPDATED_AT];
	if (dateString) {
		self.updatedAt = [[[Cocoafish defaultCocoafish] jsonDateFormatter] dateFromString:dateString];
	}
    
    self.tags = [jsonResponse objectForKey:@"tags"];
    
    self.customFields = [jsonResponse objectForKey:@"custom_fields"];

	return self;
}

-(id)initWithId:(NSString *)objectId
{
    if (!objectId) {
        [self release];
        return nil;
    }
    if ((self = [super init])) {
        self.objectId = objectId;
        self.updatedAt = [NSDate date];
        self.createdAt = [NSDate date];
    }
    return self;
    
}

+(NSArray *)arrayWithJsonResponse:(NSDictionary *)jsonResponse class:(Class)class jsonTag:(NSString *)jsonTag
{
    NSArray *jsonArray = [jsonResponse objectForKey:jsonTag];
    NSMutableArray *results = nil; 
    if ([jsonArray count] > 0) {
        results = [NSMutableArray arrayWithCapacity:[jsonArray count]];
        for (NSDictionary *json in jsonArray) {
            id object = [[class alloc] initWithJsonResponse:json];
            if (object) {
                [results addObject:object];
            }
            [object release];
        }
    }
    return results;
}

+(NSArray *)arrayWithJsonResponse:(NSDictionary *)jsonResponse class:(Class)class
{
    return [class arrayWithJsonResponse:jsonResponse class:class jsonTag:[class jsonTag]];
}

/*-(id)copyWithZone:(NSZone *)zone  
{
    CCObject *copy = [[[self class] allocWithZone:zone] init];
    copy.objectId = [_objectId copy];
    copy.updatedAt = [_updatedAt copy];
    copy.createdAt = [_createdAt copy];
    copy.tags = [_tags copy];
    copy.customFields = [_customFields copy];
    copy.etag = [_etag copy];
    copy.lastModified = [_lastModified copy];

    return copy;
}*/

/*- (NSString *)description {
    return [NSString stringWithFormat:@"id: %@\n\tcreatedAt: %@\n\tupdatedAt: %@", 
                self.objectId,
                [self.createdAt description],
                [self.updatedAt description]];
}*/

-(NSString *)arrayDescription:(NSArray *)array
{
    return [NSString stringWithFormat:@"{\n\t%@\n\t}", [array componentsJoinedByString:@"\n\t"]];
}

// class name on the server
+(NSString *)modelName
{
    [NSException raise:@"Please implement modelName in the subclass" format:@"modelName unset"];   
    return nil;
}

+(NSString *)jsonTag
{
    [NSException raise:@"Please implement jsonTag in the subclass" format:@"jsonTag unset"];  
    return nil;
}

-(void)dealloc
{
	self.createdAt = nil;
	self.updatedAt = nil;
	self.objectId = nil;
    self.tags = nil;
    self.customFields = nil;
    self.etag = nil;
    self.lastModified = nil;
	[super dealloc];
}

@end
