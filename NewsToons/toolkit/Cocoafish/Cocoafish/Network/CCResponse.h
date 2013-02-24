//
//  CCResponse.h
//  Demo
//
//  Created by Wei Kong on 12/15/10.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

@class CCMeta;
@class CCPagination;

@interface CCResponse : NSObject {
	CCMeta *_meta;
	NSDictionary *_response; // parsed json response in NSDictionary format
    NSDictionary *_jsonResponse; // original json reponse including meta
	NSArray *_responses; // If this is a compound response, it contains an array of responses
}

@property (nonatomic, retain, readonly) CCMeta *meta;
@property (nonatomic, retain, readonly) NSDictionary *response;
@property (nonatomic, retain, readonly) NSArray *responses;

-(id)initWithJsonData:(NSData *)jsonData;
-(NSArray *)getObjectsOfType:(Class)objectType;
-(NSString *)jsonResponse;
-(NSString *)jsonMeta;

@end

@interface CCPagination : NSObject {
@private
    int _page;
    int _perPage;
    int _totalPages;
    int _totalResults;
}

@property (nonatomic, readonly) int totalResults;
@property (nonatomic, readonly) int totalPages;
@property (nonatomic, readonly) int page;
@property (nonatomic, readonly) int perPage;

-(id)initWithJsonResponse:(NSDictionary *)jsonResponse;

@end

@interface CCMeta : NSObject {
	NSString *_status;
	NSInteger _code;
	NSString *_message;
	NSString *_methodName; // method name
    CCPagination *_pagination;
}

@property (nonatomic, readonly) NSInteger code;
@property (nonatomic, retain, readonly) NSString *message;
@property (nonatomic, retain, readonly) NSString *status;
@property (nonatomic, retain, readonly) NSString *methodName;
@property (nonatomic, retain, readonly) CCPagination *pagination;

-(id)initWithJsonResponse:(NSDictionary *)jsonResponse;
@end
