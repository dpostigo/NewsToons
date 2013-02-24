//
//  CloudLogin.h
//  
//  Created by Dani Postigo on 6/8/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import <Foundation/Foundation.h>
#import "BasicOperation.h"
#import "CCRequest.h"


@interface CloudLogin : BasicOperation <CCRequestDelegate> {

}

- (id) init;
- (void) ccrequest: (CCRequest *) request didSucceed: (CCResponse *) response;


@end