//
//  CCAcl.m
//  Demo
//
//  Created by Wei Kong on 6/20/12.
//  Copyright (c) 2012 Cocoafish Inc. All rights reserved.
//

#import "CCAcl.h"
#import "CCUser.h"

@interface CCAcl ()
@property (nonatomic, retain, readwrite) NSString *name;
@property (nonatomic, readwrite) Boolean publicRead;
@property (nonatomic, readwrite) Boolean publicWrite;
@property (nonatomic, retain, readwrite) NSArray *readers;
@property (nonatomic, retain, readwrite) NSArray *writers;
@property (nonatomic, retain, readwrite) CCUser *user;
@end

@implementation CCAcl
@synthesize name = _name;
@synthesize publicRead = _publicRead;
@synthesize publicWrite = _publicWrite;
@synthesize readers = _readers;
@synthesize writers = _writers;
@synthesize user = _user;


-(id)initWithJsonResponse:(NSDictionary *)jsonResponse
{
	self = [super initWithJsonResponse:jsonResponse];
	if (self) {
        self.name = [jsonResponse objectForKey:@"name"];
        _user = [[CCUser alloc] initWithJsonResponse:[jsonResponse objectForKey:CC_JSON_USER]];  
        _publicRead = [[jsonResponse objectForKey:@"public_read"] boolValue];
        _publicWrite = [[jsonResponse objectForKey:@"public_write"] boolValue];
        self.readers = [jsonResponse objectForKey:@"readers"];
        self.writers = [jsonResponse objectForKey:@"writers"];
        
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
    return @"acl";
}

+(NSString *)jsonTag
{
    return @"acls";
}

-(void)dealloc
{
    self.name = nil;
    self.readers = nil;
    self.writers = nil;
    self.user = nil;
    [super dealloc];
}

@end
