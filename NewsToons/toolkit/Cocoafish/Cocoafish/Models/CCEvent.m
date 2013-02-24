//
//  CCEvent.m
//  APIs
//
//  Created by Wei Kong on 4/1/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCEvent.h"
#import "CCUser.h"
#import "CCPlace.h"
#import "Cocoafish.h"

@interface CCEvent ()
@property (nonatomic, retain, readwrite) NSString *name;
@property (nonatomic, retain, readwrite) NSString *details;
@property (nonatomic, retain, readwrite) CCUser *user;
@property (nonatomic, retain, readwrite) CCPlace *place;
@property (nonatomic, retain, readwrite) NSDate *startTime;
@property (nonatomic, readwrite) NSInteger duration;
@property (nonatomic, retain, readwrite) NSString *recurring;
@property (nonatomic, readwrite) NSInteger recurringCount;
@property (nonatomic, readwrite) NSInteger numOccurrences;
@property (nonatomic, retain, readwrite) NSString *ical;
@property (nonatomic, retain, readwrite) NSDate *recurringUntil;
@end

@interface CCEventOccurrence ()
@property (nonatomic, retain, readwrite) NSDate *startTime;
@property (nonatomic, retain, readwrite) NSDate *endTime;
@property (nonatomic, retain, readwrite) CCEvent *event;
@end

@implementation CCEvent

@synthesize name = _name;
@synthesize details = _details;
@synthesize user = _user;
@synthesize place = _place;
@synthesize startTime = _startTime;
@synthesize endTime = _endTime;
@synthesize duration = _duration;
@synthesize recurring = _recurring;
@synthesize recurringCount = _recurringCount;
@synthesize numOccurrences = _numOccurrences;
@synthesize ical = _ical;
@synthesize recurringUntil = _recurringUntil;

-(id)initWithJsonResponse:(NSDictionary *)jsonResponse
{
	self = [super initWithJsonResponse:jsonResponse];
    NSString *dateString = nil;
	if (self) {
		@try {
            self.name = [jsonResponse objectForKey:CC_JSON_NAME];
			_user = [[CCUser alloc] initWithJsonResponse:[jsonResponse objectForKey:CC_JSON_USER]];
			_place = [[CCPlace alloc] initWithJsonResponse:[jsonResponse objectForKey:CC_JSON_PLACE]];

            
            dateString = [jsonResponse objectForKey:CC_JSON_START_TIME];
            if (dateString) {
                self.startTime = [[[Cocoafish defaultCocoafish] jsonDateFormatter] dateFromString:dateString];
            }
            

        }
		@catch (NSException *e) {
			NSLog(@"Error: Failed to parse Event object. Reason: %@", [e reason]);
			[self release];
			self = nil;
		}
        self.details = [jsonResponse objectForKey:CC_JSON_DETAILS];
        self.duration = [[jsonResponse objectForKey:@"duration"] intValue];
        self.recurring = [jsonResponse objectForKey:@"recurring"];
        self.recurringCount = [[jsonResponse objectForKey:@"recurring_count"] intValue];
        self.numOccurrences = [[jsonResponse objectForKey:@"num_occurrences"] intValue];
        self.ical = [jsonResponse objectForKey:@"ical"];
        dateString = [jsonResponse objectForKey:@"recurring_until"];
        if (dateString) {
            self.recurringUntil = [[[Cocoafish defaultCocoafish] jsonDateFormatter] dateFromString:dateString];
        }


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
    return @"event";
}

+(NSString *)jsonTag
{
    return @"events";
}

-(void)dealloc
{
	self.user = nil;
	self.place = nil;
	self.name = nil;
	self.details = nil;
    self.startTime = nil;
    self.recurring = nil;
    self.recurringUntil = nil;
    self.ical = nil;
	[super dealloc];
}
@end

@implementation CCEventOccurrence

@synthesize startTime = _startTime;
@synthesize endTime = _endTime;
@synthesize event = _event;


-(id)initWithJsonResponse:(NSDictionary *)jsonResponse
{
	self = [super initWithJsonResponse:jsonResponse];
	if (self) {
        NSString *dateString = nil;
		@try {
			_event = [[CCEvent alloc] initWithJsonResponse:[jsonResponse objectForKey:@"event"]];
            dateString = [jsonResponse objectForKey:CC_JSON_START_TIME];
            if (dateString) {
                self.startTime = [[[Cocoafish defaultCocoafish] jsonDateFormatter] dateFromString:dateString];
            }
            dateString = [jsonResponse objectForKey:CC_JSON_END_TIME];
            if (dateString) {
                self.endTime = [[[Cocoafish defaultCocoafish] jsonDateFormatter] dateFromString:dateString];
            }
            
        }
		@catch (NSException *e) {
			NSLog(@"Error: Failed to parse EventOccurrence object. Reason: %@", [e reason]);
			[self release];
			self = nil;
		}
	}
	return self;
}


+(NSString *)modelName
{
    return @"event_occurrence";
}

+(NSString *)jsonTag
{
    return @"event_occurrences";
}


-(void)dealloc
{
	self.startTime = nil;
	self.endTime = nil;
	self.event = nil;
	[super dealloc];
}
@end

