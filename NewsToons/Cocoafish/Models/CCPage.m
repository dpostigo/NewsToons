//
//  CCPage.m
//  Demo
//
//  Created by Wei Kong on 10/13/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCPage.h"
#import "CCUser.h"
#import "CCPhoto.h"
#import "CCPlace.h"
#import "CCFeed.h"

@interface CCPage ()
@property (nonatomic, retain, readwrite) NSString *title;
@property (nonatomic, retain, readwrite) NSString *content;
@property (nonatomic, retain, readwrite) CCUser *user;
@property (nonatomic, retain, readwrite) NSArray *admin_ids;
@property (nonatomic, retain, readwrite) NSArray *friends;
@property (nonatomic, retain, readwrite) NSNumber *friends_count;
@property (nonatomic, retain, readwrite) NSNumber *currentUserIsAdmin;
@property (nonatomic, retain, readwrite) NSNumber *currentUserIsFriend;
@property (nonatomic, readwrite) BOOL access_private;
//@property (nonatomic, retain, readwrite) CCPhoto *photo;
@property (nonatomic, retain, readwrite) NSArray *places;
@property (nonatomic, retain, readwrite) NSArray *page_ids;
@property (nonatomic, retain, readwrite) NSArray *feeds;
@end

@implementation CCPage
@synthesize title = _title;
@synthesize content = _content;
@synthesize user = _user;
@synthesize admin_ids = _admin_ids;
@synthesize friends = _friends;
@synthesize friends_count = _friends_count;
@synthesize currentUserIsAdmin = _currentUserIsAdmin;
@synthesize currentUserIsFriend = _currentUserIsFriend;
@synthesize access_private = _access_private;
//@synthesize photo = _photo;
@synthesize places = _places;
@synthesize page_ids = _page_ids;
@synthesize feeds = _feeds;

-(id)initWithJsonResponse:(NSDictionary *)jsonResponse
{
	self = [super initWithJsonResponse:jsonResponse];
	if (self) {
        self.title = [jsonResponse objectForKey:@"title"];
        _user = [[CCUser alloc] initWithJsonResponse:[jsonResponse objectForKey:CC_JSON_USER]];            
        self.content = [jsonResponse objectForKey:@"content"];
        self.admin_ids = [jsonResponse objectForKey:@"admin_ids"];
        self.friends = [CCUser arrayWithJsonResponse:jsonResponse class:[CCUser class] jsonTag:@"friends"];
     //   _photo = [[CCPhoto alloc] initWithJsonResponse:[jsonResponse objectForKey:CC_JSON_PHOTO]];
        self.access_private = [[jsonResponse objectForKey:@"access_private"] boolValue];
        NSString *tmp_str = [jsonResponse objectForKey:@"friends_count"];
        if (tmp_str) {
            self.friends_count = [NSNumber numberWithInt:[tmp_str intValue]];
        }
        tmp_str = [jsonResponse objectForKey:@"current_user_is_admin"];
        if (tmp_str) {
            self.currentUserIsAdmin = [NSNumber numberWithBool:[tmp_str boolValue]];
        }
        tmp_str = [jsonResponse objectForKey:@"current_user_is_friend"];
        if (tmp_str) {
            self.currentUserIsFriend = [NSNumber numberWithBool:[tmp_str boolValue]];
        }
        NSArray *jsonPlaces = [jsonResponse objectForKey:@"places"];
        if ([jsonPlaces count] > 0) {
            self.places = [CCPlace arrayWithJsonResponse:jsonResponse class:[CCPlace class]];
        }
        self.page_ids = [jsonResponse objectForKey:@"page_ids"];
        NSArray *jsonFeeds = [jsonResponse objectForKey:@"feeds"];
        if ([jsonFeeds count] > 0) {
            self.feeds = [CCFeed arrayWithJsonResponse:jsonResponse class:[CCFeed class]];
        }

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
    return @"page";
}

+(NSString *)jsonTag
{
    return @"pages";
}

-(void)dealloc
{
    self.title = nil;
    self.content = nil;
    self.user = nil;
    self.admin_ids = nil;
    self.friends = nil;
    self.friends_count = nil;
    self.currentUserIsFriend = nil;
    self.currentUserIsAdmin = nil;
  //  self.photo = nil;
    self.places = nil;
    self.page_ids = nil;
    self.feeds = nil;
    [super dealloc];
}
@end
