//
//  CCFile.m
//  Demo
//
//  Created by Wei Kong on 2/20/12.
//  Copyright (c) 2012 Cocoafish Inc. All rights reserved.
//

#import "CCFile.h"
#import "CCUser.h"

@interface CCFile ()
@property (nonatomic, retain, readwrite) NSString *name;
@property (nonatomic, readwrite) Boolean processed;
@property (nonatomic, retain, readwrite) NSString *url;
@property (nonatomic, retain, readwrite) CCUser *user;
@end

@implementation CCFile
@synthesize name = _name;
@synthesize processed = _processed;
@synthesize url = _url;
@synthesize user = _user;

-(id)initWithJsonResponse:(NSDictionary *)jsonResponse
{
    self = [super initWithJsonResponse:jsonResponse];
    
    if (self) {
		self.name = [jsonResponse objectForKey:@"name"];
		self.processed = [[jsonResponse objectForKey:@"processed"] boolValue];
        self.url = [jsonResponse objectForKey:@"url"];
    }
	
	return self;

}

+(NSString *)modelName
{
    return @"file";
}

+(NSString *)jsonTag
{
    return @"files";
}

-(void)dealloc
{
    self.name = nil;
    self.url = nil;
    self.user = nil;
    [super dealloc];
}

@end
