//
//  CCPlace.h
//  Demo
//
//  Created by Wei Kong on 12/15/10.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCObjectWithPhoto.h"
#import <CoreLocation/CoreLocation.h>

@interface CCPlace : CCObjectWithPhoto {

@protected
	NSString *_name;
	NSString *_address;
	NSString *_crossStreet;
	NSString *_city;
	NSString *_state; 
    NSString *_postalCode;
	NSString *_country;
	NSString *_phone;
    NSString *_website;
    NSString *_twitter;
	CLLocation *_location;
}

@property (nonatomic, retain, readonly) NSString *name;
@property (nonatomic, retain, readonly) NSString *address;
@property (nonatomic, retain, readonly) NSString *crossStreet;
@property (nonatomic, retain, readonly) NSString *city;
@property (nonatomic, retain, readonly) NSString *state;
@property (nonatomic, retain, readonly) NSString *postalCode;
@property (nonatomic, retain, readonly) NSString *country;
@property (nonatomic, retain, readonly) NSString *phone;
@property (nonatomic, retain, readonly) NSString *website;
@property (nonatomic, retain, readonly) NSString *twitter;
@property (nonatomic, retain, readonly) CLLocation *location;

@end
