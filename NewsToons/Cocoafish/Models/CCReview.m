//
//  CCReview.m
//  Demo
//
//  Created by Wei Kong on 7/29/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCReview.h"
#import "CCUser.h"

@interface CCReview ()
@property (nonatomic, readwrite) NSInteger rating;
@property (nonatomic, retain, readwrite) NSString *content;
@property (nonatomic, retain, readwrite) CCUser *user;

@end

@implementation CCReview
@synthesize rating = _rating;
@synthesize content = _content;
@synthesize user = _user;

-(id)initWithJsonResponse:(NSDictionary *)jsonResponse
{
	self = [super initWithJsonResponse:jsonResponse];
	if (self) {
		@try {
            self.rating = [[jsonResponse objectForKey:@"rating"] intValue];
			_user = [[CCUser alloc] initWithJsonResponse:[jsonResponse objectForKey:CC_JSON_USER]];            
        }
		@catch (NSException *e) {
			NSLog(@"Error: Failed to parse Review object. Reason: %@", [e reason]);
			[self release];
			self = nil;
		}
        self.content = [jsonResponse objectForKey:@"content"];
        
	}
	return self;
}

+(NSString *)modelName
{
    return @"review";
}

+(NSString *)jsonTag
{
    return @"reviews";
}

-(void)dealloc
{
    self.content = nil;
    self.user = nil;
    [super dealloc];
}
@end
