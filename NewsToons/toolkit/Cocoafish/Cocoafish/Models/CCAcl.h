//
//  CCAcl.h
//  Demo
//
//  Created by Wei Kong on 6/20/12.
//  Copyright (c) 2012 Cocoafish Inc. All rights reserved.
//

#import "CCObject.h"
#import "CCUser.h"

@interface CCAcl : CCObject
{
@private
    NSString *_name;
    CCUser *_user;
	NSArray *_readers;
    NSArray *_writers;
    Boolean _publicRead;
    Boolean _publicWrite;
}

@property (nonatomic, retain, readonly) NSString *name;
@property (nonatomic, readonly) Boolean publicRead;
@property (nonatomic, readonly) Boolean publicWrite;
@property (nonatomic, retain, readonly) NSArray *readers;
@property (nonatomic, retain, readonly) NSArray *writers;
@property (nonatomic, retain, readonly) CCUser *user;

-(id)initWithJsonResponse:(NSDictionary *)jsonResponse;

@end
