//
//  BasicView.h
//  
//  Created by Dani Postigo on 3/29/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "BasicView.h"
#import "Model.h"


@implementation BasicView {

}


- (void) awakeFromNib {
    model = [Model sharedModel];
}

- (Model *) model; {
    return [Model sharedModel];
}




- (void) dealloc {
    [super dealloc];


}




@end