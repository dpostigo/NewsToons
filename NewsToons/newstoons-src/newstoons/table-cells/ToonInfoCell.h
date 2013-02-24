//
// Created by dpostigo on 9/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "Toon.h"


@interface ToonInfoCell : UITableViewCell {

    Toon *toonObject;

    UIView *statsView;
    UILabel *likesLabel;
    UILabel *emailLabel;

    CGFloat padding;

}

@property(nonatomic, retain) Toon *toonObject;
@property(nonatomic, retain) UIView *statsView;
@property(nonatomic, retain) UILabel *likesLabel;
@property(nonatomic, retain) UILabel *emailLabel;
@property(nonatomic) CGFloat padding;
- (id) initWithStyle: (UITableViewCellStyle) style reuseIdentifier: (NSString *) reuseIdentifier toon: (Toon *) aToon;

@end