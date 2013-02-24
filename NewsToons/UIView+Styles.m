//
//  Created by dpostigo on 3/19/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import "UIView+Styles.h"


@implementation UIView (Styles)


- (void) addShadow; {
	self.layer.masksToBounds = NO;
	self.layer.shadowColor = [UIColor blackColor].CGColor;
	self.layer.shadowOffset = CGSizeMake(2, 2);
	self.layer.shadowOpacity = 1.0;
	self.layer.shadowRadius = 4.0;
	self.clipsToBounds = NO;
}

- (void) roundCorners: (CGFloat) r {
    self.layer.masksToBounds = NO;
    self.clipsToBounds = NO;
    self.layer.cornerRadius = r;
}

@end