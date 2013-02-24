//
//  CCMessage.m
//  Demo
//
//  Created by Wei Kong on 4/5/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCMessage.h"
#import "CCUser.h"

@interface CCMessage()
@property (nonatomic, retain, readwrite) NSString *threadId;
@property (nonatomic, retain, readwrite) NSString *status;
@property (nonatomic, retain, readwrite) NSString *subject;
@property (nonatomic, retain, readwrite) NSString *body;
@property (nonatomic, retain, readwrite) CCUser *from;
@property (nonatomic, retain, readwrite) NSArray *to;
@end

@implementation CCMessage

@synthesize threadId = _threadId;
@synthesize status = _status;
@synthesize subject = _subject;
@synthesize body = _body;
@synthesize from = _from;
@synthesize to = _to;


-(id)initWithJsonResponse:(NSDictionary *)jsonResponse
{
	self = [super initWithJsonResponse:jsonResponse];
	if (self) {
		@try {
            self.threadId = [jsonResponse objectForKey:CC_JSON_THREAD_ID];
            self.status = [jsonResponse objectForKey:CC_JSON_STATUS];
			_from = [[CCUser alloc] initWithJsonResponse:[jsonResponse objectForKey:CC_JSON_FROM]];
            NSArray *toArray = [jsonResponse objectForKey:CC_JSON_TO];
            
            NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[toArray count]];
            
            for (NSDictionary *toResponse in toArray) {
                CCUser *user = [[CCUser alloc] initWithJsonResponse:toResponse];
                [tmpArray addObject:user];
            }
            if ([tmpArray count] > 0) {
                self.to = tmpArray;
            }
        }
		@catch (NSException *e) {
			NSLog(@"Error: Failed to parse Message object. Reason: %@", [e reason]);
			[self release];
			self = nil;
		}
        self.subject = [jsonResponse objectForKey:CC_JSON_SUBJECT];
        self.body = [jsonResponse objectForKey:CC_JSON_BODY];

	}
	return self;
}

/*- (NSString *)description {
    return [NSString stringWithFormat:@"CCMessage:\n\tthreadId=%@\n\tstatus=%@\n\tsubject=%@\n\tbody=%@\n\tfrom=[\n\t%@\n\t]\n\tto={\n\t%@\n\t}\n\t%@",
            self.threadId, self.status, self.subject, self.body, [self.from description],
            [self arrayDescription:self.to], [super description]];
}*/

+(NSString *)modelName
{
    return @"message";
}

+(NSString *)jsonTag
{
    return @"messages";
}

-(void)dealloc
{
	self.threadId = nil;
	self.status = nil;
	self.subject = nil;
	self.body = nil;
    self.from = nil;
    self.to = nil;
	[super dealloc];
}

@end
