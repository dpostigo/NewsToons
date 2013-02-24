//
//  ${HEADER_FILENAME}
//  
//  Created by Dani Postigo on 3/27/12.
//  Copyright 2012 Dani Postigo. All rights reserved.
//  dealloc.net
//


@protocol ToonLibrarySortMode <NSObject>



typedef enum {
    ToonLibrarySortByDate,
    ToonLibrarySortByViewCount,
    ToonLibrarySortByEmailCount,
    ToonLibrarySortByRating,
    ToonLibrarySortByBest
} ToonLibrarySortMode;

@end