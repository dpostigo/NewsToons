//
//  CCFeed.m
//  Demo
//
//  Created by Wei Kong on 10/13/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCFeed.h"
#import "CCUser.h"
#import "CCPhoto.h"
#import "CCStatus.h"
#import "CCCheckin.h"
#import "CCPost.h"
#import "CCPage.h"

@interface CCFeed ()
@property (nonatomic, retain, readwrite) NSString *name;
@property (nonatomic, retain, readwrite) NSString *type;
@property (nonatomic, retain, readwrite) NSArray *objects;
@property (nonatomic, retain, readwrite) CCPage *page;
@property (nonatomic, retain, readwrite) CCUser *user;
@end

@implementation CCFeed
@synthesize name = _name;
@synthesize type = _type;
@synthesize objects = _objects;
@synthesize page = _page;
@synthesize user = _user;

-(id)initWithJsonResponse:(NSDictionary *)jsonResponse
{
	self = [super initWithJsonResponse:jsonResponse];
	if (self) {
        self.name = [jsonResponse objectForKey:@"name"];
        _user = [[CCUser alloc] initWithJsonResponse:[jsonResponse objectForKey:CC_JSON_USER]];            
        self.type = [jsonResponse objectForKey:@"type"];
        if ([self.type isEqualToString:@"Photo"]) {
            self.objects = [CCPhoto arrayWithJsonResponse:jsonResponse class:[CCPhoto class]];
        } else if ([self.type isEqualToString:@"Status"]) {
            self.objects = [CCStatus arrayWithJsonResponse:jsonResponse class:[CCStatus class]];
        } else if ([self.type isEqualToString:@"Checkin"]) {
            self.objects = [CCCheckin arrayWithJsonResponse:jsonResponse class:[CCCheckin class]];
        } else if ([self.type isEqualToString:@"Post"]) {
            self.objects = [CCPost arrayWithJsonResponse:jsonResponse class:[CCPost class]];
        }
        _page = [[CCPage alloc] initWithJsonResponse:[jsonResponse objectForKey:@"page"]];
        
	}
	return self;
}

/*- (NSString *)description {
 return [NSString stringWithFormat:@"CCEvent:\n\tname=%@\n\tdetails=%@\n\tstartTime=%@\n\tendTime=%@\n\tuser=[\n\t%@\n\t]\n\tplace=[\n\t%@\n\t]\n\t%@",
 self.name, self.details, [self.startTime description], [self.endTime description], [self.user description],
 [self.place description], [super description]];
 }*/

+(NSString *)modelName
{
    return @"feed";
}

+(NSString *)jsonTag
{
    return @"feeds";
}

-(void)dealloc
{
    self.name = nil;
    self.type = nil;
    self.objects = nil;
    self.page = nil;
    self.user = nil;
    [super dealloc];
}
@end
