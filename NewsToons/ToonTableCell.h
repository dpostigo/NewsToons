//
//  ToonTableCell.h
//  NewsToons
//
//  Created by Daniela Postigo on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Toon.h"
#import "DesktopCell.h"

@interface ToonTableCell : UITableViewCell {

    DesktopCell *cellView;
}

@property(nonatomic, retain) Toon *toonObject;
@property(nonatomic, retain) DesktopCell *cellView;


- (id) initWithStyle: (UITableViewCellStyle) style reuseIdentifier: (NSString *) reuseIdentifier;

@end
