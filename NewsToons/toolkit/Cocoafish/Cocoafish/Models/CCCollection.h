//
//  CCCollection.h
//  ZipLyne
//
//  Created by Wei Kong on 6/3/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCObject.h"

@class CCUser;
@class CCPhoto;
@class CCCollectionCount;
@interface CCCollection : CCObject {
@private
    NSString *_name;
    CCPhoto *_coverPhoto;
    CCUser *_user; // owner
    CCCollection *_parentCollection;
    CCCollectionCount *_count;
}

@property (nonatomic, retain, readonly) NSString *name;
@property (nonatomic, retain, readonly) CCPhoto *coverPhoto;
@property (nonatomic, retain, readonly) CCUser *user;
@property (nonatomic, retain, readonly) CCCollection *parentCollection;
@property (nonatomic, retain, readonly) CCCollectionCount *count;


@end


@interface CCCollectionCount : NSObject {
@private
    NSInteger _photos; // number of photos in this collection
    NSInteger _totalPhotos; // total number photos in this collection including the ones under sub collections
    NSInteger _subCollections; // number of sub collections in this collection
}

@property (nonatomic, readonly) NSInteger photos;
@property (nonatomic, readonly) NSInteger totalPhotos;
@property (nonatomic, readonly) NSInteger subCollections;
@property (nonatomic, readonly) NSInteger shares;

-(id)initWithJsonResponse:(NSDictionary *)jsonResponse;

@end