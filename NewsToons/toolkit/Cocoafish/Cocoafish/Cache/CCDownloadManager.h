//
//  CCDownloadManager.h
//  Cocoafish-ios-sdk
//
//  Created by Wei Kong on 3/8/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cocoafish.h"

@interface CCDownloadManager : NSObject <CCRequestDelegate> {
	NSMutableDictionary	*_processingPhotos; // list of photo objects or objects with a photo object that are in processing state
	NSMutableSet *_downloadInProgress; // objects (photo, document, etc) that are currently being downloaded
	//NSTimer *_downloadNotificationTimer;	// Timer to send out download finished notifcation
	//NSTimer *_autoUpdateTimer; // timer used to get photo updates if needed
	//int _timeInterval; // used by timer
//    NSMutableDictionary *_pendingPhotoDownloadQueue; // If a download request was issued before the photo was processed
    unsigned long long int _curCacheSize;
    NSDate *_lastCacheCleanupTime;
}


-(void)downloadPhoto:(CCPhoto *)photo size:(NSString *)size;
//-(void)addProcessingPhoto:(CCPhoto *)photo parent:(CCObject *)parent;
@end
