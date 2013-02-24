//
//  CCChat.m
//  APIs
//
//  Created by Wei Kong on 6/17/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCChat.h"
#import "CCUser.h"

@interface CCChatGroup ()
@property (nonatomic, retain, readwrite) NSArray *participate_users;

@end

@interface CCChat()

@property (nonatomic, retain, readwrite) NSString *message;
@property (nonatomic, retain, readwrite) CCUser *from;
@property (nonatomic, retain, readwrite) CCChatGroup *chatGroup;

@end

@implementation CCChatGroup

@synthesize participate_users = _participate_users;

-(id)initWithJsonResponse:(NSDictionary *)jsonResponse
{
	if ((self = [super initWithJsonResponse:jsonResponse])) {
        self.participate_users = [CCUser arrayWithJsonResponse:jsonResponse class:[CCUser class] jsonTag:@"participate_users"];
	}
	
	return self;
}

+(NSString *)modelName
{
    return @"chat_group";
}

+(NSString *)jsonTag
{
    return @"chat_groups";
}

-(void)dealloc
{
    self.participate_users = nil;
	[super dealloc];
}
@end

@implementation CCChat
@synthesize message = _message;
@synthesize from = _from;
@synthesize chatGroup = _chatGroup;

-(id)initWithJsonResponse:(NSDictionary *)jsonResponse
{
	if ((self = [super initWithJsonResponse:jsonResponse])) {
		self.message = [jsonResponse objectForKey:CC_JSON_MESSAGE];
        _from = [[CCUser alloc] initWithJsonResponse:[jsonResponse objectForKey:@"from"]];
        _chatGroup = [[CCChatGroup alloc] initWithJsonResponse:[jsonResponse objectForKey:@"chat_group"]];
	}
	
	return self;
}

/*- (NSString *)description {
 return [NSString stringWithFormat:@"CCStatus:\n\tmessage: '%@'\n\t%@",
 self.message, [super description]];
 }*/

+(NSString *)modelName
{
    return @"chat";
}

+(NSString *)jsonTag
{
    return @"chats";
}

-(void)dealloc
{
	self.message = nil;
    self.from = nil;
    self.chatGroup = nil;
	[super dealloc];
}

@end
