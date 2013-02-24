//
//  CCPhoto.h
//  Cocoafish-ios-sdk
//
//  Created by Wei Kong on 2/7/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCObject.h"

@class ASIFormDataRequest;
@class UIImage;
@class CCRequest;
@class CCUser;
@class CCExif;
typedef enum PhotoSize {
	CC_SQUARE_75,
	CC_THUMB_100,
	CC_SMALL_240,
	CC_MEDIUM_500,
	CC_MEDIUM_640,
	CC_LARGE_1024,
	CC_ORIGINAL
} PhotoSize;

@interface CCPhoto : CCObject {
	
	NSString *_filename;
	int _size;
	NSString *_md5;
    NSString *_title;
    NSDate *_takenAt;
	BOOL _processed;
	NSString  *_contentType;
	NSDictionary *_urls;
    NSDate *_customDate; // custom set date for sorting photos in different orders
    NSArray *_collections;
    CCUser *_user;
    CCExif *_exif;
    
}

@property (nonatomic, retain, readonly) NSString *filename;
@property (nonatomic, readonly) int size;
@property (nonatomic, retain, readonly) NSArray *collections;
@property (nonatomic, retain, readonly) NSString *md5;
@property (nonatomic, retain, readonly) NSString *title;
@property (nonatomic, retain, readonly) NSDate *takenAt;
@property (nonatomic, readonly) BOOL processed;
@property (nonatomic, retain, readonly) NSString *contentType;
@property (nonatomic, retain, readonly) NSDate *customDate;
@property (nonatomic, retain, readonly) NSDictionary *urls;
@property (nonatomic, retain, readonly) CCUser *user;
@property (nonatomic, retain, readonly) CCExif *exif;


-(NSString *)getImageUrl:(NSString *)photoSize;
-(UIImage *)getImageForPhotoSize:(NSString *)photoSize;
-(NSString *)localPathForPhotoSize:(NSString *)photoSize;

/* obsolete */
-(UIImage *)getImage:(PhotoSize)photoSize;
-(NSString *)localPath:(PhotoSize)photoSize;
+(NSString *)getPhotoSizeString:(PhotoSize)photoSize;
@end

@interface CCExif : NSObject {
@private
    NSString *_model;
    NSDate *_createDate;
    NSString *_make;
    NSInteger _height;
    NSInteger _width;
    NSString *_shutterSpeed;
}

@property (nonatomic, retain, readonly) NSString *model;
@property (nonatomic, retain, readonly) NSDate *createDate;
@property (nonatomic, retain, readonly) NSString *make;
@property (nonatomic, readonly) NSInteger height;
@property (nonatomic, readonly) NSInteger width;
@property (nonatomic, retain, readonly) NSString *shutterSpeed;

-(id)initWithJsonResponse:(NSDictionary *)jsonResponse;

@end

