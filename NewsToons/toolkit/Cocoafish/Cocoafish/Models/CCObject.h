//
//  CCObject.h
//  Demo
//
//  Created by Wei Kong on 12/15/10.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

// Super class for all CC model classes
#import <Foundation/Foundation.h>
#import "CCConstants.h"


@interface CCObject : NSObject {

	NSString * _objectId;
	NSDate * _createdAt;
	NSDate *_updatedAt;
    NSArray *_tags;
    NSDictionary *_customFields;
    NSString *_etag;
    NSString *_lastModified;
}

@property (nonatomic, retain, readonly) NSString *objectId;
@property (nonatomic, retain, readonly) NSDate *createdAt;
@property (nonatomic, retain, readonly) NSDate *updatedAt;
@property (nonatomic, retain, readonly) NSArray *tags;
@property (nonatomic, retain, readonly) NSDictionary *customFields;
@property (nonatomic, retain, readwrite) NSString *etag;
@property (nonatomic, retain, readwrite) NSString *lastModified;

-(id)initWithJsonResponse:(NSDictionary *)jsonResponse;

-(id)initWithId:(NSString *)objectId;

+(NSArray *)arrayWithJsonResponse:(NSDictionary *)jsonResponse class:(Class)klass;
+(NSArray *)arrayWithJsonResponse:(NSDictionary *)jsonResponse class:(Class)klass jsonTag:(NSString *)jsonTag;

-(NSString *)arrayDescription:(NSArray *)array;

+(NSString *)modelName; // class name on the server
+(NSString *)jsonTag;
@end
