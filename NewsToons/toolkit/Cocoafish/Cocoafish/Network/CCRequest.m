//
//  CCRequest.m
//  APIs
//
//  Created by Wei Kong on 4/2/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCRequest.h"
#import "CCResponse.h"
#import "Cocoafish.h"
#import "OAuthCore.h"
#import <YAJL/YAJL.h>
#import "AssetsLibrary/AssetsLibrary.h"
#import "WBImage.h"

#define CC_DEFAULT_PHOTO_MAX_SIZE  0 // original photo size 
#define CC_DEFAULT_JPEG_COMPRESSION   1 // best photo quality

@interface CCRequest ()
+(NSString *)generateRequestId;
-(void)main;
-(void)initCommon;
-(void)addOauthHeaderToRequest;
-(NSData *)imageDataFromALAsset:(ALAsset *)alasset;
-(void)checkPhotoParams:(NSDictionary *)paramDict;
+(NSString *)generateFullRequestUrl:(NSString *)partialUrl httpProtocol:(NSString *)httpProtocol additionalParams:(NSArray *)additionalParams;
@property (nonatomic, readwrite, retain) NSString *requestId;
@property (nonatomic, readwrite, retain) CCAttachment *attachment;
@end

@implementation CCRequest
@synthesize requestId = _requestId;
@synthesize attachment = _attachment;
@synthesize requestDelegate = _requestDelegate;

-(id)initWithURL:(NSURL *)newURL
{
    self = [super initWithURL:newURL];
    if (self) {
        [self initCommon];
    }
    return self;
}


-(id)initWithDelegate:(id)requestDelegate httpMethod:(NSString *)httpMethod baseUrl:(NSString *)baseUrl paramDict:(NSDictionary *)paramDict
{
    return [self initWithDelegate:requestDelegate httpProtocol:@"https" httpMethod:httpMethod baseUrl:baseUrl paramDict:paramDict];
}

-(id)initHttpsWithDelegate:(id)requestDelegate httpMethod:(NSString *)httpMethod baseUrl:(NSString *)baseUrl paramDict:(NSDictionary *)paramDict
{
    return [self initWithDelegate:requestDelegate httpProtocol:@"https" httpMethod:httpMethod baseUrl:baseUrl paramDict:paramDict];
}

-(id)initWithDelegate:(id)requestDelegate httpProtocol:(NSString *)httpProtocol httpMethod:(NSString *)httpMethod baseUrl:(NSString *)baseUrl paramDict:(NSDictionary *)paramDict
{
    NSMutableArray *paramArray = nil;
    // sanity check, see if user passed in photo as a key
    if ([paramDict objectForKey:@"photo"] != nil) {
        [NSException raise:@"please use addPhotoALAsset or addPhotoUIImage to add a photo upload" format:@"invalid paramter"];
    }
    NSArray *keys = [paramDict allKeys];
    if ([httpMethod isEqualToString:@"GET"] || [httpMethod isEqualToString:@"DELETE"]) {
        // construct the url
        if ([paramDict count] > 0) {
            paramArray = [NSMutableArray arrayWithCapacity:[paramDict count]];
            for (NSString *key in keys) {
                id valueObject = [paramDict valueForKey:key];
                NSString *value = nil;
                // URL encode string
                NSRange range = [key rangeOfString : @"[]"];
                
                BOOL isArray = NO;
                if (range.location == [key length] - 2) {
                    isArray = YES;
                }

                // URL encode string
                if ([valueObject isKindOfClass:[NSArray class]]) {
                    if (isArray) {
                        // convert to mulple fields
                        for (id item in valueObject) {
                            if ([item isKindOfClass:[NSString class]]) {
                                value = item;
                            } else {
                                value = [item description];
                            }
                            value = encodeToPercentEscapeString(value);
                            [paramArray addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
                            
                        }
                        continue;

                    } else {
                        // concatenate the array
                        value = [valueObject componentsJoinedByString:@","];
                    }
                } else if (![valueObject isKindOfClass:[NSString class]]) {
                    value = [valueObject yajl_JSONString];
                } else {
                    value = (NSString *)valueObject;
                }

                value = encodeToPercentEscapeString(value);
                [paramArray addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
            }
        }
    }
    
    NSString *urlPath = [CCRequest generateFullRequestUrl:baseUrl httpProtocol:httpProtocol additionalParams:paramArray];
    
	NSURL *newUrl = [NSURL URLWithString:urlPath];
    self = [super initWithURL:newUrl];
    if (self) {
        CCLog(@"CCRequest Url: %@", [newUrl absoluteString]);
        [self setRequestMethod:httpMethod]; 
        self.requestDelegate = requestDelegate;       
        if ([httpMethod isEqualToString:@"POST"] || [httpMethod isEqualToString:@"PUT"]) {
            // add post body
            for (NSString *key in keys) {
                id valueObject = [paramDict valueForKey:key];
                NSString *value = nil;
                // URL encode string
                NSRange range = [key rangeOfString : @"[]"];
                
                BOOL isArray = NO;
                if (range.location == [key length] - 2) {
                    isArray = YES;
                }
                if ([valueObject isKindOfClass:[NSArray class]] && isArray) {
                    // convert to mulple fields
                    for (id item in valueObject) {
                        if ([item isKindOfClass:[NSString class]]) {
                            [self addPostValue:item forKey:key];
                        } else {
                            [self addPostValue:[item description] forKey:key];
                        }
                        
                    }
                    continue;
                } else if ([valueObject isKindOfClass:[NSArray class]] && ![baseUrl isEqualToString:@"keyvalues/set.json"]) {
                    // concatenate the array
                    value = [valueObject componentsJoinedByString:@","];

                } else if (([valueObject isKindOfClass:[NSDictionary class]] || [valueObject isKindOfClass:[NSArray class]]) && [baseUrl isEqualToString:@"keyvalues/set.json"]) {
                    value = [valueObject yajl_JSONString];
                    // if it is keyvalues set, convert array or dictionary to json and set type to json
                    [self setPostValue:@"json" forKey:@"type"];
                } else if (![valueObject isKindOfClass:[NSString class]]) {
                    value = [valueObject yajl_JSONString];
                } else {
                    value = (NSString *)valueObject;
                }

                [self setPostValue:value forKey:key];
                
            }
            
        }
        [self initCommon];
    }
    return self;
    
}

-(void)initCommon
{
    self.requestId = [CCRequest generateRequestId];
    self.timeOutSeconds = CC_TIMEOUT;
    [self setDelegate:self];
    [self setDidFinishSelector:@selector(requestDone:)];
    [self setDidFailSelector:@selector(requestFailed:)];
    [self addRequestHeader:@"Accepts-Encoding" value:@"gzip"];   
    _photos = [[NSMutableArray arrayWithCapacity:0] retain];
    _photoParams = [[NSMutableArray arrayWithCapacity:0] retain];
}

// use UUID
+(NSString *)generateRequestId
{
    // Create universally unique identifier (object)
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    
    // Get the string representation of CFUUID object.
    NSString *uuidStr = [(NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidObject) autorelease];
    
    // If needed, here is how to get a representation in bytes, returned as a structure
    // typedef struct {
    //   UInt8 byte0;
    //   UInt8 byte1;
    //   ...
    //   UInt8 byte15;
    // } CFUUIDBytes;
  //  CFUUIDBytes bytes = CFUUIDGetUUIDBytes(uuidObject);
    
    CFRelease(uuidObject);
    
    return uuidStr;
}

-(void)main
{
    // attach all the photos if there are any
    if ([_photos count] == [_photoParams count]) {
        int i = 0;
        for (id photo in _photos) {
            NSDictionary *params = [_photoParams objectAtIndex:i];
            NSNumber *maxPhotoSizeNSNumber = nil; 
            NSNumber *jpegCompressionNSNumber = nil;
            if ([params isKindOfClass:[NSDictionary class]]) {
                maxPhotoSizeNSNumber = [params objectForKey:@"max_size"];
                jpegCompressionNSNumber= [params objectForKey:@"jpeg_compression"];
            }
            int maxPhotoSize = CC_DEFAULT_PHOTO_MAX_SIZE;
            double jpegCompression = CC_DEFAULT_JPEG_COMPRESSION;
            BOOL needProcess = NO;
            if (maxPhotoSizeNSNumber) {
                maxPhotoSize = [maxPhotoSizeNSNumber intValue];
                needProcess = YES;
            }
            if (jpegCompressionNSNumber) {
                jpegCompression = [jpegCompressionNSNumber doubleValue];
                needProcess = YES;
            }
            NSData *photoData = nil;
            NSString *fileName = @"photo.jpg";
            NSString *contentType = @"image/jpeg";
            NSString *key = nil;
            if ([_photos count] == 1) {
                key = @"photo";
            } else {
                key = @"photos[]";
            }
            if ([photo isKindOfClass:[ALAsset class]]) {
                if ([[photo defaultRepresentation] respondsToSelector:@selector(filename)]) {
                    fileName = [[photo defaultRepresentation] filename];
                }
                // alasset
                if (needProcess) {
                    UIImage *image = [UIImage imageWithCGImage:[[photo defaultRepresentation] fullResolutionImage]];   
                    UIImage *processedImage = [image scaleAndRotateImage:maxPhotoSize];
                    // convert to jpeg and save
                    photoData = UIImageJPEGRepresentation(processedImage, jpegCompression);      
                } else {
                    contentType = @"application/octet-stream";
                    // get filename and type
                    NSString *uti = [[photo defaultRepresentation] UTI];
                    NSArray *tokens = [NSArray arrayWithArray:[uti componentsSeparatedByString:@"."]];
                    for (NSString *token in tokens) {
                        if ([[token lowercaseString] isEqualToString:@"jpg"] || 
                            [[token lowercaseString] isEqualToString:@"jpeg"] || 
                            [[token lowercaseString] isEqualToString:@"png"] || 
                            [[token lowercaseString] isEqualToString:@"gif"]) {
                            contentType = [[[NSString alloc] initWithFormat:@"image/%@", token] autorelease];
                            break;
                        }
                    }
                    photoData = [self imageDataFromALAsset:photo];
                }
            } else if ([photo isKindOfClass:[UIImage class]]) {
                // uiimage
                UIImage *processedImage = [photo scaleAndRotateImage:maxPhotoSize];
                
                // convert to jpeg and save
                photoData = UIImageJPEGRepresentation(processedImage, jpegCompression);
            }

            [self setData:photoData withFileName:fileName andContentType:contentType forKey:key];
            i++;
        }
    }
    [self addOauthHeaderToRequest];
    [super main];
}

-(CCResponse *)startSynchronousRequest
{
  /*  [self setDelegate:nil];
    [self setDidFailSelector:nil];
    [self setDidFailSelector:nil];*/
    [super startSynchronous];	
    CCResponse *response = nil;
	if (![self error]) {
        CCLog(@"Received %@", [self responseString]);
        response = [[[CCResponse alloc] initWithJsonData:[self responseData]] autorelease];
	}
    return response;
}

-(void)addPhotoALAsset:(ALAsset *)alasset paramDict:(NSDictionary *)paramDict
{
    if (!alasset) {
        return;
    }
    if (!([self.requestMethod isEqualToString:@"PUT"] || [self.requestMethod isEqualToString:@"POST"])) {
        [NSException raise:@"addPhotoALAsset is only supported with PUT and POST" format:@"invalid operation"];
    }
    if (![[alasset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
        [NSException raise:@"ALAsset is not a photo" format:@"invalid object type"];
    }
    
    [_photos addObject:alasset];
    [self checkPhotoParams:paramDict];
}
                    
-(void)addPhotoUIImage:(UIImage *)image paramDict:(NSDictionary *)paramDict
{
    if (!image) {
        return;
    }
    if (!([self.requestMethod isEqualToString:@"PUT"] || [self.requestMethod isEqualToString:@"POST"])) {
        [NSException raise:@"addPhotoUIImage is only supported with PUT and POST" format:@"invalid operation"];
    }
    [_photos addObject:image];
    [self checkPhotoParams:paramDict];

}

-(void)checkPhotoParams:(NSDictionary *)paramDict
{
    NSNumber *maxPhotoSize = [paramDict objectForKey:@"max_photo_size"];
    NSNumber *jpegCompression = [paramDict objectForKey:@"jpeg_compression"];
    if (maxPhotoSize && [maxPhotoSize intValue] <= 0) {
        [NSException raise:@"max_photo_size must be greater than zero" format:@"invalid parameter"];
    }
    if (jpegCompression && ([jpegCompression doubleValue]< 0 || [jpegCompression doubleValue] > 1)) {
        [NSException raise:@"jpeg_compression must be greater than or equal to zero and less than or equal to 1" format:@"invalid parameter"];
    }
    if (paramDict == nil) {
        [_photoParams addObject:[NSNull null]];
    } else {
        [_photoParams addObject:paramDict];
    }
}

                   
- (NSData *)imageDataFromALAsset:(ALAsset *)alasset {
	ALAssetRepresentation *assetRep = [alasset defaultRepresentation];
    
	NSUInteger size = [assetRep size];
	uint8_t *buff = malloc(size);
    
	NSError *err = nil;
	NSUInteger gotByteCount = [assetRep getBytes:buff fromOffset:0 length:size error:&err];
    
	if (gotByteCount) {
		if (err) {
			NSLog(@"!!! Error reading asset: %@", [err localizedDescription]);
			[err release];
			free(buff);
			return nil;
		}
	}
    
	return [NSData dataWithBytesNoCopy:buff length:size freeWhenDone:YES];
}
    

#pragma mark - REST Call support
-(void)addOauthHeaderToRequest
{
	if (![[Cocoafish defaultCocoafish] getOauthConsumerKey] || ![[Cocoafish defaultCocoafish] getOauthConsumerSecret]) {
		// nothing to add
		return;
	}
	BOOL postRequest = NO;
	if ([self.requestMethod isEqualToString:@"POST"] || [self.requestMethod isEqualToString:@"PUT"]) {
		postRequest = YES;
	}
	NSData *body = nil;
    
	if (postRequest) {
		[self buildPostBody];
		body = [self postBody];
	}
	
	NSString *header = OAuthorizationHeader([self url],
											[self requestMethod],
											body,
											[[Cocoafish defaultCocoafish] getOauthConsumerKey],
											[[Cocoafish defaultCocoafish] getOauthConsumerSecret],
											@"",
											@"");
	[self addRequestHeader:@"Authorization" value:header];
}

+(NSString *)generateFullRequestUrl:(NSString *)partialUrl httpProtocol:(NSString *)httpProtocol additionalParams:(NSArray *)additionalParams
{
	NSString *url = nil;
	NSString *appKey = [[Cocoafish defaultCocoafish] getAppKey];
    NSString *paramsString = nil;
    NSString *backendUrl = [[Cocoafish defaultCocoafish] apiURL];
    if ([additionalParams count] > 0) {
        paramsString = [additionalParams componentsJoinedByString:@"&"];
    }
	if ([appKey length] > 0) {
		if (paramsString) {
			url = [NSString stringWithFormat:@"%@://%@/%@?key=%@&%@", httpProtocol, backendUrl, partialUrl, appKey, 
                   paramsString];
		} else {
			url = [NSString stringWithFormat:@"%@://%@/%@?key=%@", httpProtocol, backendUrl, partialUrl, appKey];
		}
	} else if (paramsString) {
		url = [NSString stringWithFormat:@"%@://%@/%@?%@", httpProtocol, backendUrl, partialUrl, paramsString];
	} else {
		url = [NSString stringWithFormat:@"%@://%@/%@", httpProtocol, backendUrl, partialUrl];
	}
	return url;
}

-(void)dealloc
{
    self.requestId = nil;
    self.attachment = nil;
    [_photos release];
    [_photoParams release];
    [super dealloc];
}

#pragma ASIHTTPrequest Callback
-(void)requestDone:(CCRequest *)origRequest
{
    CCLog(@"Received %@", [origRequest responseString]);
    CCResponse *response = [[CCResponse alloc] initWithJsonData:[origRequest responseData]];
    if (response && ([origRequest responseStatusCode] == 200 || [origRequest responseStatusCode] == 304)) {
        // If response is ok(200) or not modified (304
        if ([_requestDelegate respondsToSelector:@selector(ccrequest:didSucceed:)]) {
            [_requestDelegate ccrequest:origRequest didSucceed:response];
        }
    } else {
       // something failed on the server
        if ([_requestDelegate respondsToSelector:@selector(ccrequest:didFailWithError:)]) {
          
            NSMutableDictionary *errorUserInfo = [NSMutableDictionary dictionaryWithCapacity:2];
            if (response && [response.meta.message length] > 0) {
                [errorUserInfo setObject:[NSString stringWithFormat:@"%@", response.meta.message] forKey:NSLocalizedDescriptionKey];
            }
            if (response.meta) {
                [errorUserInfo setObject:response.meta forKey:@"meta"];
            }
            NSError *requestError = [NSError errorWithDomain:CC_DOMAIN code:CC_SERVER_ERROR userInfo:errorUserInfo];
            [_requestDelegate ccrequest:origRequest didFailWithError:requestError];
        }
    }
    [response release];
    
}

-(void)requestFailed:(CCRequest *)origRequest
{
    if ([_requestDelegate respondsToSelector:@selector(ccrequest:didFailWithError:)]) {
        [_requestDelegate ccrequest:origRequest didFailWithError:[origRequest error]];
    }
    
}
@end


// Used by Joshua
@implementation CCDeleteRequest
@synthesize deleteClass = _deleteClass;

-(id)initWithURL:(NSURL *)newURL deleteClass:(Class)deleteClass
{
    self = [super initWithURL:newURL];
    if (self) {
        _deleteClass = deleteClass;
        [self setRequestMethod:@"DELETE"];
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}
@end
