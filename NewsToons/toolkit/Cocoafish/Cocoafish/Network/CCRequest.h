//
//  CCRequest.h
//  APIs
//
//  Created by Wei Kong on 4/2/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@class ALAsset;

@class CCObject;
@class CCResponse;
@class CCUploadImage;
@class CCAttachment;

@protocol CCRequestDelegate;

// use format data request all the time
@interface CCRequest : ASIFormDataRequest {
    id<CCRequestDelegate> _requestDelegate;
    NSString *_requestId;
    NSMutableArray *_photos; // list of photos to upload
    NSMutableArray *_photoParams; // parameter corresponding to _photos
    CCAttachment *_attachment;
}

-(id)initWithDelegate:(id)requestDelegate httpMethod:(NSString *)httpMethod baseUrl:(NSString *)baseUrl paramDict:(NSDictionary *)paramDict;
// to make a http call
-(id)initHttpsWithDelegate:(id)requestDelegate httpMethod:(NSString *)httpMethod baseUrl:(NSString *)baseUrl paramDict:(NSDictionary *)paramDict;
-(id)initWithDelegate:(id)requestDelegate httpProtocol:(NSString *)protocal httpMethod:(NSString *)httpMethod baseUrl:(NSString *)baseUrl paramDict:(NSDictionary *)paramDict;

-(CCResponse *)startSynchronousRequest;
-(void)addPhotoALAsset:(ALAsset *)alasset paramDict:(NSDictionary *)paramDict;
-(void)addPhotoUIImage:(UIImage *)image paramDict:(NSDictionary *)paramDict;

@property(nonatomic, assign) id<CCRequestDelegate> requestDelegate;
@property (nonatomic, retain, readonly) NSString *requestId;
@property (nonatomic, retain, readonly) CCAttachment *attachment;
@end

// Delegate callback methods
@protocol CCRequestDelegate <NSObject>

@optional

// generic callback, if we received custom objects or above callbacks were not implemented
-(void)ccrequest:(CCRequest *)request didSucceed:(CCResponse *)response;

-(void)ccrequest:(CCRequest *)request didFailWithError:(NSError *)error;

@end

// used by joshua
@interface  CCDeleteRequest  :  ASIHTTPRequest  {
@private
    Class _deleteClass;
}

@property (nonatomic, readonly) Class deleteClass;

-(id)initWithURL:(NSURL *)newURL deleteClass:(Class)deleteClass;
@end