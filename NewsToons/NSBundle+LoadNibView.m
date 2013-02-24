#import "NSBundle+LoadNibView.h"

@implementation NSBundle(LoadNibView)

+ (id) loadNibView:(NSString*)className
{
    return [[[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil] objectAtIndex:0];
}

@end