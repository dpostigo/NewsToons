//
//  CCReview.h
//  Demo
//
//  Created by Wei Kong on 7/29/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCObject.h"

@class CCUser;
@interface CCReview : CCObject {
    NSInteger _rating;
    NSString *_content;
	CCUser *_user;
}

@property (nonatomic, readonly) NSInteger rating;
@property (nonatomic, retain, readonly) NSString *content;
@property (nonatomic, retain, readonly) CCUser *user;


@end
