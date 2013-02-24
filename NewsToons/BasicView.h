//
//  BasicView.h
//  
//  Created by Dani Postigo on 3/29/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import <Foundation/Foundation.h>

@class Model;


@interface BasicView : UIView {
    Model *model;
}

@property (readonly) Model *model;


//- (void) addSelector: (SEL) aSelector name: (NSString *) aName withObject: (id) anObject;

@end