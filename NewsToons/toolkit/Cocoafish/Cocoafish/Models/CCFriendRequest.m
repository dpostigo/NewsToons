//
//  CCFriendRequest.m
//  APIs
//
//  Created by Wei Kong on 6/20/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCFriendRequest.h"

#import "CCUser.h"

@interface CCFriendRequest ()

@property (nonatomic, retain, readwrite) CCUser *user;
@end

@implementation CCFriendRequest 
@synthesize user = _user;

-(id)initWithJsonResponse:(NSDictionary *)jsonResponse
{
	self = [super initWithJsonResponse:jsonResponse];
	if (self) {
        _user = [[CCUser alloc] initWithJsonResponse:[jsonResponse objectForKey:@"user"]];
	}
	return self;
}

+(NSString *)modelName
{
    return @"friend_request";
}

+(NSString *)jsonTag
{
    return @"friend_requests";
}

-(void)dealloc
{
    self.user = nil;
    [super dealloc];
}
@end