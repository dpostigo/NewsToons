//
//  CCFeed.h
//
//  Created by Wei Kong on 10/13/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCObject.h"

@class CCPage;
@class CCUser;
@interface CCFeed : CCObject {
@private
    NSString *_name;
    CCUser *_user;
    NSString *_type;
    NSArray *_objects;
    CCPage *_page;
}

@property (nonatomic, retain, readonly) NSString *name;
@property (nonatomic, retain, readonly) NSString *type;
@property (nonatomic, retain, readonly) CCUser *user;
@property (nonatomic, retain, readonly) NSArray *objects;
@property (nonatomic, retain, readonly) CCPage *page;

-(id)initWithJsonResponse:(NSDictionary *)jsonResponse;

@end
