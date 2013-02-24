//
//  BasicNibView.h
//  NewsToons
//
//  Created by Daniela Postigo on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicView.h"

@interface BasicNibView : BasicView {
    IBOutlet UIView *subview;
    NSString *nibName;
}

@property(nonatomic, retain) NSString *nibName;
@property(nonatomic, retain) IBOutlet UIView *subview;
- (void) loadedFromNib;
- (id) initWithNibName: (NSString *) nibNameOrNil;
- (id) initWithFrame: (CGRect) frame;
- (void) setup;

@end
