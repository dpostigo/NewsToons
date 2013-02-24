 //
//  CCDownloadManager.m
//  Cocoafish-ios-sdk
//
//  Created by Wei Kong on 3/8/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCDownloadManager.h"
#import "CCPhoto.h"
#import "Cocoafish.h"
#import "CCResponse.h"
#import "CCRequest.h"
//#import "ASIDownloadCache.h"

#define DEFAULT_TIME_INTERVAL	3
#define MAX_CACHE_SIZE      5242880 // file cache size 5M
#define MAX_CACHE_TIME      86400   // maximum file cached for 1 day

@interface CCDownloadManager ()

//@property (nonatomic, retain, readwrite) NSTimer *autoUpdateTimer;
-(void)cleanupCache; 
@end

@implementation CCDownloadManager
//@synthesize autoUpdateTimer = _autoUpdateTimer;

-(id)init
{
	self = [super init];
	if (self) {
		_downloadInProgress = [[NSMutableSet alloc] init];
		_processingPhotos = [[NSMutableDictionary alloc] init];
        [self cleanupCache];
	}
	return self;
}

-(void)downloadPhoto:(CCPhoto *)photo size:(NSString *)size
{
	@synchronized(self) {
        NSString *urlPath = [photo getImageUrl:size];
        if (!urlPath) {
            return;
        }
      /*  if (!urlPath && !photo.processed) {
            // we don't have the photo url info yet because the photo is being processed, put in the queue
            if (_pendingPhotoDownloadQueue == nil) {
                _pendingPhotoDownloadQueue = [[NSMutableDictionary alloc] init];
            }
            NSMutableArray *sizes = [_pendingPhotoDownloadQueue objectForKey:photo.objectId];
            if (sizes == nil) {
                sizes = [NSMutableArray arrayWithObject:[NSNumber numberWithInt:size]];
                [_pendingPhotoDownloadQueue setObject:sizes forKey:photo.objectId];
            } else {
                Boolean found = false;
                for (NSNumber *cursize in sizes) {
                    if ([cursize intValue] == size) {
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    [sizes addObject:[NSNumber numberWithInt:size]];
                }
            }
            

            // reset process autotimer
            if (self.autoUpdateTimer == nil) {
                
                _timeInterval = DEFAULT_TIME_INTERVAL;
                self.autoUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:(_timeInterval)
                                                                    target:self
                                                                  selector:@selector(updateProcessingPhotos)
                                                                  userInfo:nil
                                                                   repeats:NO];
            }
            return;
        }*/
        NSString *downloadPath = [photo localPathForPhotoSize:size];
		if ([_downloadInProgress containsObject:downloadPath]) {
			// download already in progress, no op
			return;
		}
        
        NSURL *url = [NSURL URLWithString:urlPath];
        ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
        [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:photo, @"object", size, @"size", nil]];
        [request setDownloadDestinationPath:[photo localPathForPhotoSize:size]];
      //  [request setDownloadCache:[ASIDownloadCache sharedCache]]; 
        // set callbacks
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(downloadDone:)];
        [request setDidFailSelector:@selector(downloadFailed:)];
        [request startAsynchronous];
		return;
	}
}

-(void)downloadDone:(CCRequest *)request
{
    // Cleanup file cache if necessary
    [self cleanupCache];
	
	NSNotification * myNotification = [NSNotification notificationWithName:@"DownloadFinished" object:[Cocoafish defaultCocoafish] userInfo:request.userInfo];
	[[NSNotificationQueue defaultQueue] enqueueNotification:myNotification postingStyle:NSPostNow];	
	@synchronized(self) {
        NSString *size = [request.userInfo objectForKey:@"size"];
        CCObject *object = [request.userInfo objectForKey:@"object"];
		if ([object class] == [CCPhoto class]) {
			// it is a photo download
			[_downloadInProgress removeObject:[(CCPhoto *)object localPathForPhotoSize:size]];
		}
	}
} 
	
-(void)downloadFailed:(CCRequest *)request
{
	NSNotification * myNotification = [NSNotification notificationWithName:@"DownloadFailed" object:[Cocoafish defaultCocoafish] userInfo:request.userInfo];
	[[NSNotificationQueue defaultQueue] enqueueNotification:myNotification postingStyle:NSPostNow];	
} 

/*-(void)addProcessingPhoto:(CCPhoto *)photo parent:(CCObject *)parent;
{
	if (!photo) {
		return;
	}
    if (parent == nil) {
        // set parnt to photo self if no parent was given
        parent = photo;
    }
	@synchronized(self) {
        CCObject *existingParent = [_processingPhotos objectForKey:photo.objectId];
        if (existingParent && [existingParent.objectId isEqualToString:parent.objectId]) {
            return;
        }
        Boolean found = NO;
        CCObject *foundObject = [_processingPhotos objectForKey:photo.objectId];
        if (foundObject && ([foundObject.objectId isEqualToString:parent.objectId] || [foundObject.objectId isEqualToString:photo.objectId] || [parent.objectId isEqualToString:photo.objectId])) {
            // we get the photo ojbect first, then its parent object, so have to check all conditions
            found = YES;
        }
        [_processingPhotos setObject:parent forKey:photo.objectId];

		
		if (self.autoUpdateTimer != nil) {
			[self.autoUpdateTimer invalidate];
			self.autoUpdateTimer = nil;
		}
		
        if (!found) {
            _timeInterval = DEFAULT_TIME_INTERVAL;
        }
		self.autoUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:(_timeInterval)
																target:self
															  selector:@selector(updateProcessingPhotos)
															  userInfo:nil
															   repeats:NO];
		
	}
}

-(void)updateProcessingPhotos
{
	@synchronized(self) {
		self.autoUpdateTimer = nil;
		
		NSArray *objectIds;
		if ([_processingPhotos count] > 100) {
			// we will check 100 at a time
			NSRange theRange;
			
			theRange.location = 0;
			theRange.length = 100;
			
			objectIds = [[_processingPhotos allKeys] subarrayWithRange:theRange];
		} else {
			objectIds = [_processingPhotos allKeys]; 
		}

		if ([objectIds count] > 0) {
			// construct the request
            NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:1];
            for (NSString *objectId in objectIds) {
                CCObject *parent = [_processingPhotos objectForKey:objectId];
              //  NSString *key = [NSString stringWithFormat:@"%@_ids", [parent modelName]];
                NSString *key = [NSString stringWithFormat:@"%@_ids", [[parent class] modelName]];
                NSMutableArray *ids = [paramDict objectForKey:key];
                if (ids == nil) {
                    ids = [NSMutableArray arrayWithObject:parent.objectId];
                    [paramDict setObject:ids forKey:key];
                    
                } else {
                    [ids addObject:parent.objectId];
                }
            }
            
            CCRequest *request = [[[CCRequest alloc] initWithDelegate:self httpMethod:@"GET" baseUrl:@"objects/show.json" paramDict:paramDict] autorelease];

            [request startAsynchronous];
		}
		
	}
}

-(void)ccrequest:(CCRequest *)request didSucceed:(CCResponse *)response
{
    NSArray *types = [NSArray arrayWithObjects:NSStringFromClass([CCPhoto class]), NSStringFromClass([CCUser class]), NSStringFromClass([CCCheckin class]), NSStringFromClass([CCStatus class]), NSStringFromClass([CCEvent class]),  NSStringFromClass([CCPlace class]),nil];
    
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:1];
    for (NSString *type in types) {
        Class class = NSClassFromString(type);
        NSArray *array = [response getObjectsOfType:class];
        if ([array count] > 0) {
            [objects addObjectsFromArray:array];
        }
    }
    
    NSMutableDictionary *processedPhotos = [NSMutableDictionary dictionaryWithCapacity:1];

	@synchronized(self) {	
        for (CCObject *object in objects) {
            CCPhoto *photo = nil;
            if ([object class] == [CCPhoto class]) {
                photo = (CCPhoto *)object;
            }  else if ([object isKindOfClass:[CCObjectWithPhoto class]]) {
                photo = ((CCObjectWithPhoto *)object).photo;
            } else {
                continue;
            }

            if (photo.processed) {
                [_processingPhotos removeObjectForKey:photo.objectId];
                [processedPhotos setObject:photo forKey:photo.objectId];
                NSArray *sizes = [_pendingPhotoDownloadQueue objectForKey:photo.objectId];
                // there are some pending download, perform them now since we have the urls
                for (NSNumber *size in sizes) {
                    [photo getImage:[size intValue]];
                }
                [_pendingPhotoDownloadQueue removeObjectForKey:photo.objectId];
            }
        }
		
	}
    if ([_processingPhotos count] > 0) {
        // there are still some photos are being processed on the server
        if (_autoUpdateTimer != nil) {
            [self.autoUpdateTimer invalidate];
            self.autoUpdateTimer = nil;
        }
        // stop trying after 1 minutes
        if (_timeInterval < 3600) {
            _timeInterval = _timeInterval * 2;
        
            self.autoUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:(_timeInterval)
                                                                target:self
                                                                selector:@selector(updateProcessingPhotos)
                                                                userInfo:nil
                                                                repeats:NO];               
        }
    }
	if ([processedPhotos count] > 0) {
		// send out notification
		NSDictionary *dict = [NSDictionary dictionaryWithObject:[processedPhotos allKeys] forKey:@"photoIds"];
		
		NSNotification * myNotification = [NSNotification notificationWithName:@"PhotosProcessed" object:[Cocoafish defaultCocoafish] userInfo:dict];
		[[NSNotificationQueue defaultQueue] enqueueNotification:myNotification postingStyle:NSPostNow];	
	}
	
}

-(void)ccrequest:(CCRequest *)request didFailWithError:(NSError *)error
{
	// restart the timer
	@synchronized(self) {
		if (_autoUpdateTimer == nil) {
			if (_timeInterval < 3600) {
				_timeInterval = _timeInterval * 2;
			}
			self.autoUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:(_timeInterval)
																	target:self
																  selector:@selector(updateProcessingPhotos)
																  userInfo:nil
																   repeats:NO];
		}
	}
}*/


-(void)cleanupCache
{
    @synchronized(self) {
        // Get the list of cached files by create date, (last access date would be better but don't know how to
        // get it on IOS
        NSError* error = nil;
        NSArray* filesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[Cocoafish defaultCocoafish].cocoafishDir error:&error];
        if(error != nil) {
            NSLog(@"Error in reading files: %@", [error localizedDescription]);
            return;
        }
        if ([filesArray count] == 0) {
            return;
        }

        if (_lastCacheCleanupTime != nil && [[NSDate date] timeIntervalSinceDate:_lastCacheCleanupTime] < 5) {
            // we just checked less than 5 seconds ago, do not cleanup cache more than every 5 seconds
            return;
        }
        [_lastCacheCleanupTime release];
        _lastCacheCleanupTime = [[NSDate date] retain];

        unsigned long long int fileSize = 0;

        // sort by creation date
        NSMutableArray* filesAndProperties = [NSMutableArray arrayWithCapacity:[filesArray count]];
        NSDate *oldestFileDate= nil;
        for(NSString* file in filesArray) {
            NSString* filePath = [[Cocoafish defaultCocoafish].cocoafishDir stringByAppendingPathComponent:file];
            NSDictionary* properties = [[NSFileManager defaultManager]
                                        attributesOfItemAtPath:filePath
                                        error:&error];
            
            if(error == nil)
            {
                NSDate* modDate = [properties objectForKey:NSFileModificationDate];
                if (oldestFileDate == nil) {
                    oldestFileDate = modDate;
                } else if ([oldestFileDate compare:modDate] == NSOrderedAscending) {
                    oldestFileDate = modDate;
                }
                [filesAndProperties addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                               filePath, @"path",
                                               modDate, @"lastModDate", 
                                               [NSNumber numberWithUnsignedLongLong:[properties fileSize]], @"size",
                                               nil]];   
                fileSize += [properties fileSize];

            }
        }
        
        if (fileSize <= MAX_CACHE_SIZE && (oldestFileDate && [[NSDate date] timeIntervalSinceDate:oldestFileDate] < MAX_CACHE_TIME) ) {
            // if cache is smaller than the max and the oldest file is less than one day old, do nothing
            return;
        }
        
        // sort using a block
        // order inverted as we want latest date first
        NSArray* sortedFiles = [filesAndProperties sortedArrayUsingComparator:
                                ^(id path1, id path2)
                                {                               
                                    // compare 
                                    NSComparisonResult comp = [[path1 objectForKey:@"lastModDate"] compare:
                                                               [path2 objectForKey:@"lastModDate"]];
                                   /* // invert ordering
                                    if (comp == NSOrderedDescending) {
                                        comp = NSOrderedAscending;
                                    }
                                    else if(comp == NSOrderedAscending){
                                        comp = NSOrderedDescending;
                                    }*/
                                    return comp;                                
                                }];
        
        // Delete the oldest ones
        for (NSDictionary *file in sortedFiles) {
            if ([[NSDate date] timeIntervalSinceDate:[file objectForKey:@"lastModDate"]] < MAX_CACHE_TIME && fileSize < MAX_CACHE_TIME) {
                break;
            }
            if ([[NSFileManager defaultManager] removeItemAtPath:[file objectForKey:@"path"] error:&error] != YES) {
                NSLog(@"Unable to delete file: %@", [error localizedDescription]);
                continue;
            }
            fileSize -= [[file objectForKey:@"size"] unsignedLongLongValue];
            if (fileSize < MAX_CACHE_SIZE) {
                break;
            }
        }
    }

}

-(void)dealloc
{
    [_lastCacheCleanupTime release];
	[super dealloc];
	
}
@end

