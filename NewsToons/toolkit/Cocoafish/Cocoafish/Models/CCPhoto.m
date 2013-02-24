//
//  CCPhoto.m
//  Cocoafish-ios-sdk
//
//  Created by Wei Kong on 2/7/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCPhoto.h"
#import "Cocoafish.h"
#import "CCDownloadManager.h"
#import "CCRequest.h"
#import "WBImage.h"

@interface CCPhoto ()

@property (nonatomic, retain, readwrite) NSString *filename;
@property (nonatomic, readwrite) int size;
@property (nonatomic, retain, readwrite) NSArray *collections;
@property (nonatomic, retain, readwrite) NSString *md5;
@property (nonatomic, retain, readwrite) NSString *title;
@property (nonatomic, retain, readwrite) NSDate *takenAt;
@property (nonatomic, readwrite) BOOL processed;
@property (nonatomic, retain, readwrite) NSString *contentType;
@property (nonatomic, retain, readwrite) NSDictionary *urls;
@property (nonatomic, retain, readwrite) NSDate *customDate;
@property (nonatomic, retain, readwrite) CCUser *user;
@property (nonatomic, retain, readwrite) CCExif *exif;


-(void)handlePhotoProcessed:(NSNotification *)notification;

@end

@interface CCExif ()
@property (nonatomic, retain, readwrite) NSString *model;
@property (nonatomic, retain, readwrite) NSDate *createDate;
@property (nonatomic, retain, readwrite) NSString *make;
@property (nonatomic, readwrite) NSInteger height;
@property (nonatomic, readwrite) NSInteger width;
@property (nonatomic, retain, readwrite) NSString *shutterSpeed;
@end

@implementation CCPhoto
@synthesize filename = _filename;
@synthesize size = _size;
@synthesize collections = _collections;
@synthesize md5 = _md5;
@synthesize title = _title;
@synthesize processed = _processed;
@synthesize contentType = _contentType;
@synthesize urls = _urls;
@synthesize customDate = _customDate;
@synthesize user = _user;
@synthesize exif = _exif;
@synthesize takenAt = _takenAt;

-(id)initWithJsonResponse:(NSDictionary *)jsonResponse {

	if ((self = [super initWithJsonResponse:jsonResponse])) {
		self.filename = [jsonResponse objectForKey:CC_JSON_FILENAME];
		self.size = [[jsonResponse objectForKey:CC_JSON_SIZE] intValue];
        self.collections = [CCCollection arrayWithJsonResponse:jsonResponse class:[CCCollection class]];
		self.md5 = [jsonResponse objectForKey:CC_JSON_MD5];
        self.title = [jsonResponse objectForKey:CC_JSON_TITLE];
        
        NSString *takenAt = [jsonResponse objectForKey:CC_JSON_TAKEN_AT];
        if (takenAt) {
            self.takenAt = [[[Cocoafish defaultCocoafish] jsonDateFormatter] dateFromString:takenAt];
        }
        
		self.processed = [[jsonResponse objectForKey:CC_JSON_PROCESSED] boolValue];
		self.contentType = [jsonResponse objectForKey:CC_JSON_CONTENT_TYPE];
		self.urls = [jsonResponse objectForKey:CC_JSON_URLS];
        _user = [[CCUser alloc] initWithJsonResponse:[jsonResponse objectForKey:CC_JSON_USER]];
		
        NSString *dateString = [jsonResponse objectForKey:@"custom_date"];
		if (dateString) {
			self.customDate = [[[Cocoafish defaultCocoafish] jsonDateFormatter] dateFromString:dateString];
		}
        
        _exif = [[CCExif alloc] initWithJsonResponse:[jsonResponse objectForKey:@"exif"]];
        
	/*	if (self.processed == NO && [[Cocoafish defaultCocoafish] downloadManagerEnabled]) {
			// Photo hasn't been processed on the server, add to the download manager queue 
			// it will pull for its status periodically.
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePhotoProcessed:) name:@"PhotosProcessed" object:[Cocoafish defaultCocoafish]];
			[[Cocoafish defaultCocoafish].downloadManager addProcessingPhoto:self parent:nil];
		}*/
			
	}
	
	return self;
}

/*- (NSString *)description {
    return [NSString stringWithFormat:@"CCPhoto:\n\tfilename: %@\n\tsize: %d\n\tmd5: %@\n\tprocessed: %d\n\tcontentType :%@\n\ttakenAt: %@\n\turls: %@\n\t%@",
            self.filename, self.size, self.md5, 
            self.processed, self.contentType, self.takenAt, [self.urls description], [super description]];
}*/

+(NSString *)modelName
{
    return @"photo";
}

+(NSString *)jsonTag
{
    return @"photos";
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	self.filename = nil;
	self.collections = nil;
	self.md5 = nil;
    self.title = nil;
	self.contentType = nil;
	self.urls = nil;
    self.user = nil;
    self.exif = nil;
	[super dealloc];
}

-(void)handlePhotoProcessed:(NSNotification *)notification
{
	NSDictionary *userInfo = [notification userInfo];
    
	NSDictionary *photos = [userInfo valueForKey:@"photos"];
    CCPhoto *updatedPhoto = [photos objectForKey:self.objectId];
    if (updatedPhoto) {
        self.urls = updatedPhoto.urls;
        self.processed = YES;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
}

-(NSString *)getImageUrl:(NSString *)photoSize
{
    @synchronized(self) {
        return [_urls objectForKey:photoSize];
    }
    
}
/*
-(NSString *)getImageUrl:(PhotoSize)photoSize
{
	@synchronized(self) {
		switch (photoSize) {
			case CC_SQUARE_75:
				return [_urls objectForKey:@"square_75"];
			case CC_THUMB_100:
				return [_urls objectForKey:@"thumb_100"];
			case CC_SMALL_240:
				return [_urls objectForKey:@"small_240"];
			case CC_MEDIUM_500:
				return [_urls objectForKey:@"medium_500"];
			case CC_MEDIUM_640:
				return [_urls objectForKey:@"medium_640"];
			case CC_LARGE_1024:
				return [_urls objectForKey:@"large_1024"];			
			case CC_ORIGINAL:
				return [_urls objectForKey:@"original"];
			default:
                [NSException raise:@"Invalid Photo Size" format:@"Unknown photo size",photoSize];
				break;
		}
	}
	return nil;
			
}*/

+(NSString *)getPhotoSizeString:(PhotoSize)photoSize
{
    switch (photoSize) {
        case CC_SQUARE_75:
            return @"square_75";
        case CC_THUMB_100:
            return @"thumb_100";
        case CC_SMALL_240:
            return @"small_240";
        case CC_MEDIUM_500:
            return @"medium_500";
        case CC_MEDIUM_640:
            return @"medium_640";
        case CC_LARGE_1024:
            return @"large_1024";			
        case CC_ORIGINAL:
            return @"original";
        default:
            return nil;
    }
}
-(UIImage *)getImage:(PhotoSize)photoSize
{
    UIImage *image = [UIImage imageWithContentsOfFile:[self localPath:photoSize]];
    if (!image) {
        [[Cocoafish defaultCocoafish].downloadManager downloadPhoto:self size:[CCPhoto getPhotoSizeString:photoSize]];
        // try again if the image was just downloaded
        image = [UIImage imageWithContentsOfFile:[self localPath:photoSize]];
    }
    return image;
}

-(NSString *)localPath:(PhotoSize)photoSize
{
    if (photoSize < CC_SQUARE_75 || photoSize > CC_ORIGINAL) {
        [NSException raise:@"Invalid Photo Size" format:@"Unknown photo size",photoSize];
    }
	return [NSString stringWithFormat:@"%@/%@_%d", [Cocoafish defaultCocoafish].cocoafishDir, self.objectId, photoSize];
}

-(UIImage *)getImageForPhotoSize:(NSString *)photoSize
{
    UIImage *image = [UIImage imageWithContentsOfFile:[self localPathForPhotoSize:photoSize]];
    if (!image) {
        [[Cocoafish defaultCocoafish].downloadManager downloadPhoto:self size:photoSize];
        // try again if the image was just downloaded
        image = [UIImage imageWithContentsOfFile:[self localPathForPhotoSize:photoSize]];
    }
    return image;
    
}

-(NSString *)localPathForPhotoSize:(NSString *)photoSize
{
	return [NSString stringWithFormat:@"%@/%@_%d", [Cocoafish defaultCocoafish].cocoafishDir, self.objectId, photoSize];
}

@end

@implementation CCExif
@synthesize model = _model;
@synthesize createDate = _createDate;
@synthesize make = _make;
@synthesize height = _height;
@synthesize width = _width;
@synthesize shutterSpeed = _shutterSpeed;

-(id)initWithJsonResponse:(NSDictionary *)jsonResponse
{
    if (!jsonResponse) {
        [self release];
        return nil;
    }
    self = [super init];
    if (self) {
        self.model = [jsonResponse objectForKey:@"model"];

        NSString *dateString = [jsonResponse objectForKey:@"create_date"];
		if (dateString) {
			self.createDate = [[[Cocoafish defaultCocoafish] exifDateFormatter] dateFromString:dateString];
		}
        
        self.make = [jsonResponse objectForKey:@"make"];
        self.height = [[jsonResponse objectForKey:@"height"] intValue];
        self.width = [[jsonResponse objectForKey:@"width"] intValue];
        self.shutterSpeed = [jsonResponse objectForKey:@"shutter_speed"];

    }
    return self;
                            
}

-(void)dealloc
{
    self.model = nil;
    self.createDate = nil;
    self.make = nil;
    self.shutterSpeed = nil;
    [super dealloc];
}

@end
