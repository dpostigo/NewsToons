//
//  CCChat.h
//  APIs
//
//  Created by Wei Kong on 6/17/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCObjectWithPhoto.h"

@class CCUser;

@interface CCChatGroup : CCObject {
@private
    NSArray *_participate_users;
}
@property (nonatomic, retain, readonly) NSArray *participate_users;

@end

@interface CCChat : CCObjectWithPhoto {
    NSString *_message;
    CCUser *_from;
    CCChatGroup *_chatGroup;
}

@property (nonatomic, retain, readonly) NSString *message;
@property (nonatomic, retain, readonly) CCUser *from;
@property (nonatomic, retain, readonly) CCChatGroup *chatGroup;

@end
