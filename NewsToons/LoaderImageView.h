//
//  LoaderImageView.h
//  NewsToons
//
//  Created by Daniela Postigo on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoaderImageView : UIImageView   {
    BOOL showIndicator;
    UIView *placeholder;
    UIImageView *imageView;
}

@property ( nonatomic, retain ) UIView * placeholder;


@end
