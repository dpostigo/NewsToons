//
//  BasicOperation.h
//  
//  Created by Dani Postigo on 6/8/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import <Foundation/Foundation.h>

#import "Model.h"

@interface BasicOperation : NSOperation {

    Model *_model;
}

@property ( nonatomic, assign ) Model *_model;


- (id) init;

@end