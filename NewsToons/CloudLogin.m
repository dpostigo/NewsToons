//
//  CloudLogin.h
//  
//  Created by Dani Postigo on 6/8/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "CloudLogin.h"
#import "CCRequest.h"
#import "CCKeyValuePair.h"
#import "CCResponse.h"
#import "Cocoafish.h"




@implementation CloudLogin {

}


- (id) init {
    self = [super init];
    if ( self ) {

    }

    return self;

}


- (void) main {
    [super main];



    NSMutableDictionary * paramDict = [NSMutableDictionary dictionaryWithCapacity: 1];
    [paramDict setObject: @"dani@elasticcreative.com" forKey: @"login"];
    [paramDict setObject: @"rastas10" forKey: @"password"];

    CCRequest * request = [[[CCRequest alloc] initWithDelegate: nil httpMethod: @"POST" baseUrl: @"users/login.json" paramDict: paramDict] autorelease];
    [request startSynchronous];

}


- (void) ccrequest: (CCRequest *) request didSucceed: (CCResponse *) response {
   


}


@end