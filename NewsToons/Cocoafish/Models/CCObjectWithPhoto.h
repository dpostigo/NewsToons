//
//  CCObjectWithPhoto.h
//  Demo
//
//  Created by Wei Kong on 5/14/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCObject.h"

// Base CCObject with an embedded photo
@class CCPhoto;
@interface CCObjectWithPhoto : CCObject {
    CCPhoto *_photo;
}
@property (nonatomic, retain, readonly) CCPhoto *photo;

@end
