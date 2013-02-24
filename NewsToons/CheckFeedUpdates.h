//
//  CheckFeedUpdates.h
//  
//  Created by Dani Postigo on 6/11/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import <Foundation/Foundation.h>
#import "BasicXMLOperation.h"


@interface CheckFeedUpdates : BasicXMLOperation {

    NSMutableString *dateString;
    NSMutableString *flashEmbedCode;
}

@property(nonatomic, retain) NSMutableString *dateString;
@property(nonatomic, retain) NSMutableString *flashEmbedCode;

@end