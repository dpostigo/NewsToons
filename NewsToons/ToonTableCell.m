//
//  ToonTableCell.m
//  NewsToons
//
//  Created by Daniela Postigo on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ToonTableCell.h"

@implementation ToonTableCell

@synthesize cellView;



- (void) dealloc {
    [cellView release];
    [super dealloc];
}



- (Toon *) toonObject; {
    return cellView.toonObject;
}

- (void) setToonObject: (Toon *) aToonObject {
    cellView.toonObject = aToonObject;

}

- (id) initWithStyle: (UITableViewCellStyle) style reuseIdentifier: (NSString *) reuseIdentifier {
    self = [super initWithStyle: style reuseIdentifier: reuseIdentifier];
    if (self) {


        self.cellView = [[[DesktopCell alloc] initWithFrame: CGRectMake(0, 0, 320, 85)] autorelease];
        [self.contentView addSubview: cellView];
        cellView.badge.hidden = YES;
    }
    return self;
}

- (void) setSelected: (BOOL) selected animated: (BOOL) animated {
    [super setSelected: selected animated: animated];
}


@end
