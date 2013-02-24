//
//  NSString+Addons.m
//  NewsToons
//
//  Created by Daniela Postigo on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+Addons.h"

@implementation NSString (Addons)

- (NSString *) stripURLs: (NSString *) string {
    [string retain];

    NSMutableString *mutableString = [[[NSMutableString alloc] initWithString: self] autorelease];
    NSRange range = [mutableString rangeOfString: string options: NSCaseInsensitiveSearch];

    if (range.location == NSNotFound) {
        //NSLog(@"'%@' not found in '%@'", string, self);
    }
    else {
        [mutableString deleteCharactersInRange: range];
        mutableString = [[[mutableString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] mutableCopy] autorelease];
    }

    [string release];
    return [[NSString alloc] initWithString: mutableString];
}


- (NSURL *) toURL {
    NSString *urlString = [self stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    return [NSURL URLWithString: urlString];
}


- (NSString *) stripURLString {
    NSString *siteTitle = nil;
    NSScanner *scanner = [NSScanner scannerWithString: self];
    NSString *result = nil;
    NSString *stripString = @".com";
    if ([self containsString: @".net"])
        stripString = @".net";

    else if ([self containsString: @".org"])
        stripString = @".org";

    if ([scanner scanUpToString: stripString intoString: &result]) {
        siteTitle = [result stringByAppendingString: stripString];
        siteTitle = [siteTitle stringByReplacingOccurrencesOfString: @"http://" withString: @""];
        siteTitle = [siteTitle stringByReplacingOccurrencesOfString: @"www." withString: @""];
    }

    if ([siteTitle containsString: @"blogs.nytimes.com"])
        siteTitle = @"blogs.nytimes.com";

    return siteTitle;
}


- (BOOL) containsString: (NSString *) string
                options: (NSStringCompareOptions) options {
    NSRange rng = [self rangeOfString: string options: options];
    return rng.location != NSNotFound;
}


- (BOOL) containsString: (NSString *) string {
    return [self containsString: string options: 0];
}


- (NSString *) stringBetween: (NSString *) string1 and: (NSString *) string2 {

    NSMutableString *mutableString = [[[NSMutableString alloc] initWithString: self] autorelease];
    
    NSScanner *scanner = [[NSScanner alloc] initWithString: mutableString];

    if ([scanner scanUpToString: string1 intoString: NULL]) {

        NSString *substring = [[scanner string] substringFromIndex: [scanner scanLocation]];

        mutableString = [[substring mutableCopy] autorelease];
        [mutableString replaceOccurrencesOfString: string1 withString: @"" options: NSCaseInsensitiveSearch range: NSMakeRange(0, [mutableString length])];


        [scanner release];
        scanner = [[[NSScanner alloc] initWithString: mutableString] autorelease];
        [scanner scanUpToString: string2 intoString: &mutableString];

        //NSLog(@"addon3, string = %@", string);
    }

    NSString *returnString = [[[NSString alloc] initWithString: mutableString] autorelease];
    return returnString;
}


- (NSString *) getValueBetween: (NSString *) string1 and: (NSString *) string2 {

    NSString *finalString = nil;
    NSString *string = [[[NSString alloc] initWithString: self] autorelease];
    NSScanner *scanner = [[NSScanner alloc] initWithString: string];

    if ([scanner scanUpToString: string1 intoString: NULL]) {

        string = [[scanner string] substringFromIndex: [scanner scanLocation]];


        //NSLog(@"addon1, string = %@", string);

        string = [string stringByReplacingOccurrencesOfString: string1 withString: @""];

        //NSLog(@"addon2, string = %@", string);
        //NSLog(@"scanner string = %@", scanner.string);

        [scanner release];
        scanner = [[[NSScanner alloc] initWithString: string] autorelease];
        [scanner scanUpToString: string2 intoString: &string];

        //NSLog(@"addon3, string = %@", string);
        return [[[NSString alloc] initWithString: string] autorelease];
    }
}

@end
