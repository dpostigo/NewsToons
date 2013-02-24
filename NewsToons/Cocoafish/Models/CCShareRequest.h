//
//  CCShareRequest.h
//  ZipLyne
//
//  Created by Wei Kong on 6/3/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCObject.h"

@class CCUser;
@interface CCShareRequest : CCObject {
@private
    NSString *_token;
    NSArray *_collections;
    NSArray *_photos;
    CCUser *_user;
    
}

@property (nonatomic, retain, readonly) NSString *token;
@property (nonatomic, retain, readonly) NSString *recipientEmail;
@property (nonatomic, retain, readonly) NSArray *collections;
@property (nonatomic, retain, readonly) NSArray *photos;
@property (nonatomic, retain, readonly) CCUser *user;


@end
