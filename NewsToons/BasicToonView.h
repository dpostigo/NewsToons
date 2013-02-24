//
//  BasicToonView.h
//  NewsToons
//
//  Created by Daniela Postigo on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicNibView.h"
#import "Toon.h"

@class Model;

@interface BasicToonView : BasicNibView {
	Toon *toonObject;
}

@property (nonatomic, retain) Toon *toonObject;


@end
