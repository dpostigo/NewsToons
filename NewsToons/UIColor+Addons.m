//
//  Created by dpostigo on 3/19/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UIColor+Addons.h"


@implementation UIColor (Addons)

+ (UIColor *) greyscaleColor: (CGFloat) value {
    return [UIColor colorWithWhite: value alpha: 1];
}
@end