//
//  CCCollection.m
//  ZipLyne
//
//  Created by Wei Kong on 6/3/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCCollection.h"
#import "CCPhoto.h"
#import "CCUser.h"

@interface CCCollection ()

@property (nonatomic, retain, readwrite) NSString *name;
@property (nonatomic, retain, readwrite) CCPhoto *coverPhoto;
@property (nonatomic, retain, readwrite) CCUser *user;
@property (nonatomic, retain, readwrite) CCCollection *parentCollection;
@property (nonatomic, retain, readwrite) CCCollectionCount *count;

@end

@interface CCCollectionCount()
@property (nonatomic, readwrite) NSInteger photos;
@property (nonatomic, readwrite) NSInteger totalPhotos;
@property (nonatomic, readwrite) NSInteger subCollections;
@property (nonatomic, readwrite) NSInteger shares;
@end

@implementation CCCollection

@synthesize name = _name;
@synthesize coverPhoto = _coverPhoto;
@synthesize user = _user;
@synthesize parentCollection = _parentCollection;
@synthesize count = _count;

-(id)initWithJsonResponse:(NSDictionary *)jsonResponse
{
	self = [super initWithJsonResponse:jsonResponse];
	if (self) {
        
		self.name = [jsonResponse objectForKey:@"name"];
		_coverPhoto = [[CCPhoto alloc] initWithJsonResponse:[jsonResponse objectForKey:@"cover_photo"]];
        _user = [[CCUser alloc] initWithJsonResponse:[jsonResponse objectForKey:@"user"]];

		_parentCollection = [[CCCollection alloc] initWithJsonResponse:[jsonResponse objectForKey:@"parent_collection"]];
        
        _count = [[CCCollectionCount alloc] initWithJsonResponse:[jsonResponse objectForKey:@"counts"]];

	}
	return self;
}


// class name on the server
+(NSString *)modelName
{
   return @"collection";
}

+(NSString *)jsonTag
{
    return @"collections";
}

-(void)dealloc
{
    self.name = nil;
    self.coverPhoto = nil;
    self.user = nil;
    self.parentCollection = nil;
    self.count = nil;
    [super dealloc];
}
@end

@implementation CCCollectionCount

@synthesize photos = _photos;
@synthesize totalPhotos = _totalPhotos;
@synthesize subCollections = _subCollections;
@synthesize shares = _shares;

-(id)initWithJsonResponse:(NSDictionary *)jsonResponse
{
    if (!jsonResponse) {
        [self release];
        return nil;
    }
    self = [super init];
    if (self) {
        self.photos = [[jsonResponse objectForKey:@"photos"] intValue];
        self.totalPhotos = [[jsonResponse objectForKey:@"total_photos"] intValue];
        self.subCollections = [[jsonResponse objectForKey:@"subcollections"] intValue];
        self.shares = [[jsonResponse objectForKey:@"shares"] intValue];
    }
    return self;
}
@end
