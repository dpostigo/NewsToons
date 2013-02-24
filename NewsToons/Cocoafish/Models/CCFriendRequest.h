//
//  CCFriendRequest.h
//  APIs
//
//  Created by Wei Kong on 6/20/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCObject.h"

@class CCUser;
@interface CCFriendRequest : CCObject {
@private
    CCUser *_user;
}

@property (nonatomic, retain, readonly) CCUser *user;

@end
