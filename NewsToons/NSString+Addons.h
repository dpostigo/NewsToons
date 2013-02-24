//
//  NSString+Addons.h
//  NewsToons
//
//  Created by Daniela Postigo on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addons)


- (NSString *) stripURLs: (NSString *) string;
- (NSURL *) toURL;
- (NSString *) stripURLString;

- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions)options;

- (BOOL)containsString:(NSString *)string;
- (NSString *) stringBetween: (NSString *) string1 and: (NSString *) string2;
- (NSString *) getValueBetween: (NSString *) string1 and: (NSString *) string2;


@end
