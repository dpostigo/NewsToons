//
//  ParseBestToons.h
//  
//  Created by Dani Postigo on 6/11/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


#import "ParseBestToons.h"
#import "NSMutableArray+Toon.h"

@implementation ParseBestToons

- (id) init {
    self = [super initWithFeedURL: [NSURL URLWithString: bestFeedURL]];
    if (self) {
    }
    return self;
}


- (void) main {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self initParser];

    NSLog(@"addedToons = %@", addedToons);
    NSMutableArray *bestToons = [_model toonsSortedBy: ToonLibrarySortByBest];

    for (Toon *toon in bestToons) {
        toon.isBest = NO;
    }

    [addedToons enumerateObjectsUsingBlock: ^(Toon *toon, NSUInteger index, BOOL *stop) {


        if (toon.isFavorite) {
            NSLog(@"THIS TOON IS FAVORITED.");
        }


        if ([_model.toonLibrary containsToon: toon]) {
            Toon *libraryToon = [_model.toonLibrary toonFromTitle: toon.title];
            libraryToon.isBest = YES;
        } else {
            NSLog(@"Model does not contain - %@", toon.title);

            toon.isBest = YES;
            //[_model.toonLibrary addToon: toon];
        }

        if ([toon.title isEqualToString: @"Who's On Second?"]) {

            NSLog(@"FOUND FOUND FOUND = %@", toon.title);
        }
    }];

    NSLog(@"Num of Best Toons = %u", [addedToons count]);

    [_model archive];
    [_model quickNoticeWithString: bestToonsUpdated];

    [_model notifyDelegates: @selector(bestToonsDidLoad:) object: nil];
}

@end