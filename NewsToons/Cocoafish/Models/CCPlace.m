//
//  CCPlace.m
//  Demo
//
//  Created by Wei Kong on 12/15/10.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCPlace.h"

@interface CCPlace ()
@property (nonatomic, retain, readwrite) NSString *name;
@property (nonatomic, retain, readwrite) NSString *address;
@property (nonatomic, retain, readwrite) NSString *crossStreet;
@property (nonatomic, retain, readwrite) NSString *city;
@property (nonatomic, retain, readwrite) NSString *state;
@property (nonatomic, retain, readwrite) NSString *postalCode;
@property (nonatomic, retain, readwrite) NSString *country;
@property (nonatomic, retain, readwrite) NSString *phone;
@property (nonatomic, retain, readwrite) NSString *website;
@property (nonatomic, retain, readwrite) NSString *twitter;
@property (nonatomic, retain, readwrite) CLLocation *location;
@end

@implementation CCPlace

@synthesize name = _name;
@synthesize address = _address;
@synthesize crossStreet = _crossStreet;
@synthesize city = _city;
@synthesize state = _state;
@synthesize postalCode = _postalCode;
@synthesize country = _country;
@synthesize phone = _phone;
@synthesize location = _location;
@synthesize website = _website;
@synthesize twitter = _twitter;

-(id)initWithJsonResponse:(NSDictionary *)jsonResponse
{
	self = [super initWithJsonResponse:jsonResponse];
	if (self) {
		self.name = [jsonResponse objectForKey:CC_JSON_PLACE_NAME];
		self.address = [jsonResponse objectForKey:CC_JSON_PLACE_ADDRESS];
		self.crossStreet = [jsonResponse objectForKey:CC_JSON_PLACE_CROSS_STREET];
		self.city = [jsonResponse objectForKey:CC_JSON_PLACE_CITY];
		self.state = [jsonResponse objectForKey:CC_JSON_PLACE_STATE];
        self.postalCode = [jsonResponse objectForKey:CC_JSON_PLACE_POSTAL_CODE];
		self.country = [jsonResponse objectForKey:CC_JSON_PLACE_COUNTRY];
		self.phone = [jsonResponse objectForKey:CC_JSON_PHONE];
        self.website = [jsonResponse objectForKey:CC_JSON_WEBSITE];
        self.twitter = [jsonResponse objectForKey:CC_JSON_TWITTER];
		
		// get location if there is one
		NSString *latStr = [jsonResponse objectForKey:CC_JSON_LATITUDE];
		NSString *lngStr = [jsonResponse objectForKey:CC_JSON_LONGITUDE];
		if (latStr && lngStr) {
			_location = [[CLLocation alloc] initWithLatitude:[latStr doubleValue] longitude:[lngStr doubleValue]];
		}
		
	}
	
	return self;
	
}

/*- (NSString *)description {
    return [NSString stringWithFormat:@"CCPlace:\n\tname: %@\n\taddress: %@\n\tcrossStreet: %@\n\tcity: %@\n\tstate: %@\n\tpostalCode: %@\n\tcountry :%@\n\tphone: %@\n\twebsite: %@\n\ttwitter: %@\n\tlocation: %@\n\t%@",
            self.name, self.address, self.crossStreet, self.city, self.state, self.postalCode,
            self.country, self.phone, self.website, self.twitter, [self.location description], [super description]];
}

-(id)copyWithZone:(NSZone *)zone  
{
    CCPlace *copy = [super copyWithZone:zone];
    copy.name = [_name copy];
    copy.address = [_address copy];
    copy.crossStreet = [_crossStreet copy];
    copy.city = [_city copy];
    copy.state = [_state copy];
    copy.postalCode = [_postalCode copy];
    copy.country = [_country copy];
    copy.phone = [_phone copy];
    copy.website = [_website copy];
    copy.twitter = [_twitter copy];
    copy.location= [_location copy];
    return copy;
}*/

+(NSString *)modelName
{
    return @"place";
}

+(NSString *)jsonTag
{
    return @"places";
}

-(void)dealloc
{
	self.name = nil;
	self.address = nil;
	self.crossStreet = nil;
	self.city = nil;
	self.state = nil;
    self.postalCode = nil;
	self.country = nil;
	self.phone = nil;
    self.website = nil;
    self.twitter = nil;
	self.location = nil;
	[super dealloc];
}

@end
