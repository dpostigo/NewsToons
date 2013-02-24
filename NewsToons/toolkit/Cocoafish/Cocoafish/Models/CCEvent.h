//
//  CCEvent.h
//  APIs
//
//  Created by Wei Kong on 4/1/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCObjectWithPhoto.h"

@class CCUser;
@class CCPlace;
@interface CCEvent : CCObjectWithPhoto {
@private
    NSString *_name;
    NSString *_details;
    NSDate *_startTime;
    NSInteger _duration;
    NSString *_recurring;
    NSInteger _recurringCount;
    NSDate *_recurringUntil;
    NSInteger _numOccurrences;
    NSString *_ical;
	CCUser *_user;
	CCPlace *_place;
}

@property (nonatomic, retain, readonly) NSString *name;
@property (nonatomic, retain, readonly) NSString *details;
@property (nonatomic, retain, readonly) CCUser *user;
@property (nonatomic, retain, readonly) CCPlace *place;
@property (nonatomic, retain, readonly) NSDate *startTime;
@property (nonatomic, retain, readonly) NSDate *endTime;
@property (nonatomic, readonly) NSInteger duration;
@property (nonatomic, retain, readonly) NSString *recurring;
@property (nonatomic, readonly) NSInteger recurringCount;
@property (nonatomic, retain, readonly) NSDate *recurringUntil;
@property (nonatomic, readonly) NSInteger numOccurrences;
@property (nonatomic, retain, readonly) NSString *ical;


-(id)initWithJsonResponse:(NSDictionary *)jsonResponse;
@end

@interface CCEventOccurrence : CCObject {
@private
    NSDate *_startTime;
    NSDate *_endTime;
    CCEvent *_event;
}

@property (nonatomic, retain, readonly) NSDate *startTime;
@property (nonatomic, retain, readonly) NSDate *endTime;
@property (nonatomic, retain, readonly) CCEvent *event;

@end
