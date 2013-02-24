//
//  CCStatus.m
//  Cocoafish-ios-sdk
//
//  Created by Wei Kong on 2/6/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCStatus.h"
#import "CCUser.h"
#import "CCPlace.h"
#import "CCEvent.h"

@interface CCStatus ()

@property (nonatomic, retain, readwrite) NSString *message;
@property (nonatomic, retain, readwrite) CCUser *user;
@property (nonatomic, retain, readwrite) CCEvent *event;
@property (nonatomic, retain, readwrite) CCPlace *place;

@end

@implementation CCStatus
@synthesize message = _message;
@synthesize user = _user;
@synthesize event = _event;
@synthesize place = _place;

-(id)initWithJsonResponse:(NSDictionary *)jsonResponse
{
	if ((self = [super initWithJsonResponse:jsonResponse])) {
		self.message = [jsonResponse objectForKey:CC_JSON_MESSAGE];
        _user = [[CCUser alloc] initWithJsonResponse:[jsonResponse objectForKey:CC_JSON_USER]];
        _place = [[CCPlace alloc] initWithJsonResponse:[jsonResponse objectForKey:CC_JSON_PLACE]];
        _event = [[CCEvent alloc] initWithJsonResponse:[jsonResponse objectForKey:@"event"]];
        
	}
	
	return self;
}

+(NSString *)modelName
{
    return @"status";
}

+(NSString *)jsonTag
{
    return @"statuses";
}

-(void)dealloc
{
	self.message = nil;
    self.user = nil;
    self.place = nil;
    self.event = nil;
	[super dealloc];
}

@end
