//
//  CCFile.h
//  Demo
//
//  Created by Wei Kong on 2/20/12.
//  Copyright (c) 2012 Cocoafish Inc. All rights reserved.
//

#import "CCObject.h"

@class CCUser;
@interface CCFile : CCObject {
@private
    NSString *_name;
    Boolean _processed;
    NSString *_url;
	CCUser *_user;
}

@property (nonatomic, retain, readonly) NSString *name;
@property (nonatomic, readonly) Boolean processed;
@property (nonatomic, retain, readonly) NSString *url;
@property (nonatomic, retain, readonly) CCUser *user;

-(id)initWithJsonResponse:(NSDictionary *)jsonResponse;

@end
