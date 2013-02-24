//
//  UpdateCloud.h
//  
//  Created by Dani Postigo on 6/8/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import <Foundation/Foundation.h>
#import "BasicOperation.h"
#import "CCRequest.h"


@interface UpdateCloud : BasicOperation <CCRequestDelegate> {
    Toon *toon;
}

- (id) initWithToon: (Toon *) aToon;


@end