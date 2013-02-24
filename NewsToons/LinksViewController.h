//
//  LinksViewController.h
//  
//  Created by Dani Postigo on 3/26/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import <Foundation/Foundation.h>
#import "Toon.h"
#import "BasicViewController.h"


@interface LinksViewController : BasicViewController <UITableViewDataSource, UITableViewDelegate> {
    Toon *toonObject;
    NSMutableArray * tableSource;
}

@property ( nonatomic, retain ) NSMutableArray * tableSource;


- (id) initWithToonObject: (Toon *) aToonObject;


@end