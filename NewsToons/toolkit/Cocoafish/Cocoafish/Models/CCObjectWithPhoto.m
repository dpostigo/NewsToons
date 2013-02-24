//
//  CCObjectWithPhoto.m
//  Demo
//
//  Created by Wei Kong on 5/14/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCObjectWithPhoto.h"
#import "CCPhoto.h"
#import "Cocoafish.h"
#import "CCDownloadManager.h"

@interface CCObjectWithPhoto ()
@property (nonatomic, retain, readwrite) CCPhoto *photo;
@end

@implementation CCObjectWithPhoto
@synthesize photo = _photo;

-(id)initWithJsonResponse:(NSDictionary *)jsonResponse
{
	self = [super initWithJsonResponse:jsonResponse];
	if (self) {
        _photo = [[CCPhoto alloc] initWithJsonResponse:[jsonResponse objectForKey:CC_JSON_PHOTO]];
		
     /*   if (_photo && !_photo.processed && [[Cocoafish defaultCocoafish] downloadManagerEnabled]) {
			// Photo hasn't been processed on the server, add to the download manager queue 
			// it will pull for its status periodically.
			[[Cocoafish defaultCocoafish].downloadManager addProcessingPhoto:_photo parent:self];
        }*/
	}
	return self;
}

/*- (NSString *)description {
    return [NSString stringWithFormat:@"\t%@\n\tphoto=[\n\t%@\n\t]\n\t", [super description], [self.photo description]];
}*/

-(void)dealloc
{
    self.photo = nil;
    [super dealloc];
}
@end
