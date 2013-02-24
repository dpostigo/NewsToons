//
//  CCPage.h
//  Demo
//
//  Created by Wei Kong on 10/13/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCObjectWithPhoto.h"

@class CCUser;
@class CCPhoto;
@class CCFeed;
@interface CCPage : CCObjectWithPhoto {
@private
    NSString *_title;
    NSString *_content;
	NSArray *_admin_ids;
    NSArray *_friends;
    NSNumber *_friends_count;
    NSNumber *_currentUserIsAdmin;
    NSNumber *_currentUserIsFriend;
    BOOL    _access_private;
    CCUser  *_user;
  //  CCPhoto *photo;
    NSArray *_places;
    NSArray *_page_ids;
    NSArray *_feeds;
}

@property (nonatomic, retain, readonly) NSString *title;
@property (nonatomic, retain, readonly) NSString *content;
@property (nonatomic, retain, readonly) CCUser *user;
@property (nonatomic, retain, readonly) NSArray *admin_ids;
@property (nonatomic, retain, readonly) NSArray *friends;
@property (nonatomic, retain, readonly) NSNumber *friends_count;
@property (nonatomic, retain, readonly) NSNumber *currentUserIsAdmin;
@property (nonatomic, retain, readonly) NSNumber *currentUserIsFriend;
@property (nonatomic, readonly) BOOL access_private;
//@property (nonatomic, retain, readonly) CCPhoto *photo;
@property (nonatomic, retain, readonly) NSArray *places;
@property (nonatomic, retain, readonly) NSArray *page_ids;
@property (nonatomic, retain, readonly) NSArray *feeds;

-(id)initWithJsonResponse:(NSDictionary *)jsonResponse;

@end
