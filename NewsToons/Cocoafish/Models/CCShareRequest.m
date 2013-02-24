//
//  CCShareRequest.m
//  ZipLyne
//
//  Created by Wei Kong on 6/3/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCShareRequest.h"
#import "CCUser.h"
#import "CCCollection.h"
#import "CCPhoto.h"

@interface CCShareRequest ()
@property (nonatomic, retain, readwrite) NSString *token;
@property (nonatomic, retain, readwrite) NSString *recipientEmail;
@property (nonatomic, retain, readwrite) NSArray *collections;
@property (nonatomic, retain, readwrite) NSArray *photos;
@property (nonatomic, retain, readwrite) CCUser *user;
@end

@implementation CCShareRequest 
@synthesize token = _token;
@synthesize collections = _collections;
@synthesize photos = _photos;
@synthesize user = _user;
@synthesize recipientEmail = recipientEmail_;

-(id)initWithJsonResponse:(NSDictionary *)jsonResponse
{
	self = [super initWithJsonResponse:jsonResponse];
	if (self) {
        
		self.token = [jsonResponse objectForKey:@"token"];
        self.recipientEmail = [jsonResponse objectForKey:@"recipient_email"];
        self.user = [[[CCUser alloc] initWithJsonResponse:[jsonResponse objectForKey:@"user"]] autorelease];
        self.photos = [CCPhoto arrayWithJsonResponse:jsonResponse class:[CCPhoto class]];
        self.collections = [CCCollection arrayWithJsonResponse:jsonResponse class:[CCCollection class]];
	}
	return self;
}

+(NSString *)modelName
{
    return @"share_request";
}

+(NSString *)jsonTag
{
    return @"share_requests";
}


-(void)dealloc
{
    self.token = nil;
    self.recipientEmail = nil;
    self.collections = nil;
    self.photos = nil;
    self.user = nil;
    [super dealloc];
}
@end
