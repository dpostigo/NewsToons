//
//  BasicNibView.m
//  NewsToons
//
//  Created by Daniela Postigo on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BasicNibView.h"

@implementation BasicNibView

@synthesize nibName;
@synthesize subview;


- (void) loadedFromNib {
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed: nibName owner: self options: nil];
    subview.backgroundColor = [UIColor clearColor];
    [self addSubview: subview];
}


- (id) initWithNibName: (NSString *) nibNameOrNil {
    self = [super init];
    if (self) {
        self.nibName = nibNameOrNil;
        [self loadedFromNib];
    }

    return self;
}


- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame: frame];
    if (self) {

        self.nibName = NSStringFromClass([self class]);
        [self loadedFromNib];
    }

    return self;
}


- (void) awakeFromNib {
    [super awakeFromNib];
    //[self setup];
}


- (void) setup {
}


- (void) dealloc {
    [nibName release];
    [subview release];
    [super dealloc];
}

@end
